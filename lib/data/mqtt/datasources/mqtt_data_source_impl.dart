import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/connection/connection_data_source_interface.dart';
import '../../../domain/connection/connection_repository_interface.dart';
import '../../../domain/mqtt/exceptions/mqtt.dart';
import '../../../domain/mqtt/mqtt_data_source.dart';
import '../../../utils/logger/log.dart';
import '../models/connection_status_dto.dart';

const _TAG = "MQTTDataSource";

@LazySingleton(as: IMqttDataSource)
class MqttDataSource extends IMqttDataSource {
  MqttDataSource(IConnectionDataSource connectionRepository) {
    connectionRepository.layoutStream.listen((event) async {
      Log.d("Connection status changed $event", tag: _TAG);
      if (_client != null && event.isConnected) {
        Log.d("Connection resumed trying to resume MQTT", tag: _TAG);
        await Future.delayed(const Duration(seconds: 5));
        _client.doAutoReconnect(force: true);
      }
    });

    Timer.periodic(const Duration(seconds: 30), (timer) async {
      Log.d("Periodic block started", tag: _TAG);
      final event = await connectionRepository.layoutStream.first;
      if (event.isConnected) {
        try {
          final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
          builder.addString(jsonEncode(
              ConnectionStatusDto.simple(lastMessage.keys.toList()).toJson()));
          _client.publishMessage(
            "${_mqttConfig?.clientId}/connection",
            MqttQos.exactlyOnce,
            builder.payload,
            retain: true,
          );
          Log.d("Periodic connection check valid", tag: _TAG);
        } catch (e, stack) {
          Log.e("Periodic connection check invalid",
              tag: _TAG, ex: e, stacktrace: stack);
          if (_client == null) {
            _client =
                await clear().then((value) => _login()).catchError((error) {
              Log.e("Periodic connection _login invalid", tag: _TAG, ex: error);
            });
          } else {
            _client.doAutoReconnect(force: true);
          }
        }
      } else {
        Log.d("Active connection not detected on periodic check", tag: _TAG);
      }
    });
  }

  ConnectionConfig _mqttConfig;
  MqttServerClient _client;

  final BehaviorSubject<ServerConnectionState> _connectionState =
      BehaviorSubject.seeded(ServerConnectionState.IDLE)
        ..listen((event) {
          Log.i("State $event", tag: _TAG);
        });

  final PublishSubject<TopicMessage> _topicMessageStream = PublishSubject()
    ..listen((event) {
      Log.d("Topic Message $event", tag: _TAG);
    });

  final BehaviorSubject<KtHashMap<String, MqttSubscriptionState>>
      _topicSubscriptionStream = BehaviorSubject.seeded(KtHashMap.empty())
        ..listen((event) {
          Log.i("Stream $event", tag: _TAG);
        });

  final Map<String, TopicMessage> lastMessage = {};

  @override
  Future<Unit> login(ConnectionConfig mqttConfig) async {
    if (mqttConfig == _mqttConfig &&
        _connectionState.value != ServerConnectionState.DISCONNECTED) {
      return unit;
    }

    if (_mqttConfig != null &&
        (mqttConfig.host != _mqttConfig.host ||
            mqttConfig.port != _mqttConfig.port ||
            mqttConfig.clientId != _mqttConfig.clientId)) {
      await clear(force: true);
      lastMessage.clear();
    }
    _mqttConfig = mqttConfig;
    return _connectToClient();
  }

  @override
  Stream<ServerConnectionState> get connectionStream =>
      _connectionState.stream.distinct();

  @override
  Stream<TopicMessage> getTopicMessage(String topicName) async* {
    if (lastMessage.containsKey(topicName)) {
      yield lastMessage[topicName];
    }
    yield* _topicMessageStream.stream
        .where((event) => event.topic == topicName)
        .doOnEach((message) {
      Log.i("Message received for $topicName ${message.value}", tag: _TAG);
    });
  }

  @override
  Stream<MqttSubscriptionState> getTopicSubscriptionState(String topicName) =>
      _topicSubscriptionStream.stream
          .map((event) => event[topicName] ?? MqttSubscriptionState.IDLE)
          .doOnEach((message) {
        Log.i("Subscription Status for $topicName ${message.value}", tag: _TAG);
        subscribe(topicName);
      });

  Future<Unit> _connectToClient() async {
    if (_client != null && _client.state == MqttConnectionState.connected) {
      _connectionState.add(ServerConnectionState.CONNECTED);
      Log.i('Already logged in', tag: _TAG);
      return unit;
    } else {
      _client = await _login();
      if (_client == null) {
        Log.i("Login couldn't proceed", tag: _TAG);
        throw MqttConnectionException();
      }
    }
    return connectionStream
        .firstWhere((element) => element == ServerConnectionState.CONNECTED)
        .then((value) => unit);
  }

  @override
  Future<Option<TopicMessage>> getLastTopicMessage(String topicName) async {
    if (lastMessage.containsKey(topicName)) {
      return some(lastMessage[topicName]);
    } else {
      return none();
    }
  }

  Future<MqttServerClient> _login() async {
    Log.d('''
Loggin in with:
  Host : ${_mqttConfig.host}
  Port : ${_mqttConfig.port}
  ClientId : ${_mqttConfig.clientId}
''', tag: _TAG);

    _client =
        MqttServerClient.withPort(_mqttConfig.host, "#", _mqttConfig.port);

    _client.logging(on: false);

    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.onUnsubscribed = _onUnsubscribed;
    _client.onAutoReconnect = _onAutoReconnect;
    _client.onAutoReconnected = _onAutoReconnected;
    _client.autoReconnect = true;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_mqttConfig.clientId)
        .keepAliveFor(60)
        .withWillQos(MqttQos.atMostOnce);

    if (_mqttConfig.username.isNotEmpty && _mqttConfig.password.isNotEmpty) {
      connMess.authenticateAs(_mqttConfig.username, _mqttConfig.password);
    }

    Log.d('Connecting....', tag: _TAG);
    _client.connectionMessage = connMess;

    try {
      _connectionState.add(ServerConnectionState.CONNECTING);
      await _client.connect();
    } on Exception catch (e, stack) {
      _connectionState.add(ServerConnectionState.ERROR_WHEN_CONNECTING);

      Log.e('Exception while Connecting', tag: _TAG, ex: e, stacktrace: stack);
      _client.disconnect();
      return _client = null;
    }

    if (_client.state == MqttConnectionState.connected) {
      _connectionState.add(ServerConnectionState.CONNECTED);
      _listenToTopics();
      await _subscribeToPrevious();
      Log.d('Client connected', tag: _TAG);
    } else {
      Log.e('''
           Client connection failed - disconnecting,
           status is ${_client.connectionStatus}
           ''', tag: _TAG);
      _connectionState.add(ServerConnectionState.ERROR_WHEN_CONNECTING);
      _client.disconnect();
      _client = null;
    }
    return _client;
  }

  void _listenToTopics() {
    _client?.updates?.listen((event) {
      for (final element in event) {
        final MqttPublishMessage recMess =
            element.payload as MqttPublishMessage;
        final message = TopicMessage(
          topic: element.topic,
          message:
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message),
        );
        lastMessage[element.topic] = message;
        _topicMessageStream.add(
          message,
        );
      }
    });
  }

  Future<void> _subscribeToPrevious() async {
    Log.d("Subscribing to ${lastMessage.keys}", tag: _TAG);
    for (final topicId in lastMessage.keys) {
      await subscribe(topicId);
    }
  }

  void _onUnsubscribed(String topic) {
    Log.i('Unsubscribed from topic $topic', tag: _TAG);

    final topics = _topicSubscriptionStream.value;
    topics[topic] = MqttSubscriptionState.IDLE;
    _topicSubscriptionStream.add(topics);
  }

  void _onSubscribed(String topic) {
    Log.i('Subscription confirmed for topic $topic', tag: _TAG);

    final topics = _topicSubscriptionStream.value;
    topics[topic] = MqttSubscriptionState.SUBSCRIBED;
    _topicSubscriptionStream.add(topics);
  }

  void _onDisconnected() {
    Log.e(
        'OnDisconnected client callback - Client disconnection ${_client?.connectionStatus?.returnCode}',
        tag: _TAG);
    _connectionState.add(ServerConnectionState.DISCONNECTED);
  }

  void _onConnected() {
    _connectionState.add(ServerConnectionState.CONNECTED);
    Log.d('OnConnected client callback - Client connection was sucessful',
        tag: _TAG);
  }

  void _onAutoReconnect() {
    _connectionState.add(ServerConnectionState.CONNECTING);
    Log.d('OnAutoReconnect Something went wrong, trying to autoconnect',
        tag: _TAG);
  }

  void _onAutoReconnected() {
    _connectionState.add(ServerConnectionState.CONNECTED);
    Log.d('PnAutoReconnected auto reconnect was sucessful.', tag: _TAG);
  }

  @override
  Future<Unit> subscribe(String topicName) async {
    if (_client.getSubscriptionsStatus(topicName) ==
        MqttSubscriptionStatus.active) {
      Log.i("Subscription to $topicName exists", tag: _TAG);
      return unit;
    }
    Log.i("Subscribing to $topicName", tag: _TAG);
    await _connectionState
        .firstWhere((element) => element == ServerConnectionState.CONNECTED);
    try {
      _client.subscribe(topicName, MqttQos.atMostOnce);
    } catch (e, stack) {
      Log.e("Failed to subscribte to $topicName",
          tag: _TAG, stacktrace: stack, ex: e);
    }
    return _topicSubscriptionStream
        .firstWhere(
            (element) => element[topicName] == MqttSubscriptionState.SUBSCRIBED)
        .then((value) {
      Log.i("Subscribed to $topicName", tag: _TAG);
      return unit;
    });
  }

  @override
  Future<Unit> unsubscribe(String topicName) async {
    if (_client.getSubscriptionsStatus(topicName) !=
        MqttSubscriptionStatus.active) {
      Log.i("Subscription to $topicName doesn't exists. Can't unsubscribe",
          tag: _TAG);
      return unit;
    }
    Log.i("Unsubscribing to $topicName", tag: _TAG);
    _client?.unsubscribe(topicName);
    return _topicSubscriptionStream
        .firstWhere(
            (element) => element[topicName] == MqttSubscriptionState.IDLE)
        .then((value) => unit);
  }

  @override
  Future<Unit> write(String topicName, String message) async {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    try {
      Log.i('Publishing message $message to topic $topicName', tag: _TAG);
      _client.publishMessage(
        topicName,
        MqttQos.exactlyOnce,
        builder.payload,
        retain: true,
      );
      Log.d('Published message $message to topic $topicName', tag: _TAG);
      return unit;
    } catch (e, stack) {
      Log.e("Failed to write to $topicName",
          tag: _TAG, stacktrace: stack, ex: e);
      throw UnexpectedWriteException();
    }
  }

  @override
  Future<Unit> clear({bool force}) {
    _client?.disconnect();
    _client = null;
    _connectionState.add(ServerConnectionState.DISCONNECTED);
    _topicSubscriptionStream.add(KtHashMap.empty());
    Log.d('Clearing connections', tag: _TAG);
    return Future.value(unit).then((value) {
      Log.d('Cleared Connections', tag: _TAG);
      return value;
    });
  }
}

extension on MqttClient {
  MqttConnectionState get state => connectionStatus.state;
}
