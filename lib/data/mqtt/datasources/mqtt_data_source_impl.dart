import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/mqtt/exceptions/mqtt.dart';
import '../../../domain/mqtt/mqtt_data_source.dart';
import '../../../utils/logger/log.dart';

@LazySingleton(as: IMqttDataSource)
class MqttDataSource extends IMqttDataSource {
  MqttDataSource();

  ConnectionConfig _mqttConfig;
  MqttServerClient _client;

  final BehaviorSubject<ServerConnectionState> _connectionState =
      BehaviorSubject.seeded(ServerConnectionState.IDLE)
        ..listen((event) {
          Log.d("State $event");
        });

  final PublishSubject<TopicMessage> _topicMessageStream = PublishSubject()
    ..listen((event) {
      Log.d("Topic Message $event");
    });

  final BehaviorSubject<KtHashMap<String, MqttSubscriptionState>>
      _topicSubscriptionStream = BehaviorSubject.seeded(KtHashMap.empty())
        ..listen((event) {
          Log.i("Stream $event");
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
            mqttConfig.port != _mqttConfig.port)) {
      await clear();
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
      Log.i("Message received for $topicName ${message.value}");
    });
  }

  @override
  Stream<MqttSubscriptionState> getTopicSubscriptionState(String topicName) =>
      _topicSubscriptionStream.stream
          .map((event) => event[topicName] ?? MqttSubscriptionState.IDLE)
          .doOnEach((message) {
        Log.i("Subscription Status for $topicName ${message.value}");
      });

  Future<Unit> _connectToClient() async {
    if (_client != null && _client.state == MqttConnectionState.connected) {
      _connectionState.add(ServerConnectionState.CONNECTED);
      Log.i('Already logged in');
      return unit;
    } else {
      _client = await _login();
      if (_client == null) {
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
''');

    _client =
        MqttServerClient.withPort(_mqttConfig.host, "#", _mqttConfig.port);

    _client.logging(on: false);

    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.onUnsubscribed = _onUnsubscribed;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_mqttConfig.clientId)
        .keepAliveFor(60)
        .withWillQos(MqttQos.atMostOnce);

    if (_mqttConfig.username.isNotEmpty && _mqttConfig.password.isNotEmpty) {
      connMess.authenticateAs(_mqttConfig.username, _mqttConfig.password);
    }

    Log.i('Connecting....');
    _client.connectionMessage = connMess;

    try {
      _connectionState.add(ServerConnectionState.CONNECTING);
      await _client.connect();
    } on Exception catch (e) {
      _connectionState.add(ServerConnectionState.ERROR_WHEN_CONNECTING);

      Log.e('Exception while Connecting', ex: e);
      _client.disconnect();
      return _client = null;
    }

    if (_client.state == MqttConnectionState.connected) {
      _connectionState.add(ServerConnectionState.CONNECTED);
      _listenToTopics();
      Log.i('Client connected');
    } else {
      Log.e('''
     Client connection failed - disconnecting,
     status is ${_client.connectionStatus}
     ''');
      _connectionState.add(ServerConnectionState.ERROR_WHEN_CONNECTING);
      _client.disconnect();
      _client = null;
    }
    return _client;
  }

  void _listenToTopics() {
    _client.updates.listen((event) {
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

  void _onUnsubscribed(String topic) {
    Log.i('Unsubscribed from topic $topic');

    final topics = _topicSubscriptionStream.value;
    topics[topic] = MqttSubscriptionState.IDLE;
    _topicSubscriptionStream.add(topics);
  }

  void _onSubscribed(String topic) {
    Log.i('Subscription confirmed for topic $topic');

    final topics = _topicSubscriptionStream.value;
    topics[topic] = MqttSubscriptionState.SUBSCRIBED;
    _topicSubscriptionStream.add(topics);
  }

  void _onDisconnected() {
    Log.i(
        'OnDisconnected client callback - Client disconnection ${_client.connectionStatus.returnCode}');
    _connectionState.add(ServerConnectionState.DISCONNECTED);
  }

  void _onConnected() {
    _connectionState.add(ServerConnectionState.CONNECTED);
    Log.i('OnConnected client callback - Client connection was sucessful');
  }

  @override
  Future<Unit> subscribe(String topicName) async {
    final topics = _topicSubscriptionStream.value;
    final topicSubscription = topics[topicName] ?? MqttSubscriptionState.IDLE;
    if (topicSubscription == MqttSubscriptionState.SUBSCRIBED) {
      Log.i("Subscription to $topicName exists");
      return unit;
    }
    Log.i("Subscribing to $topicName");
    _client.subscribe(topicName, MqttQos.atMostOnce);

    return _topicSubscriptionStream
        .firstWhere(
            (element) => element[topicName] == MqttSubscriptionState.SUBSCRIBED)
        .then((value) => unit);
  }

  @override
  Future<Unit> unsubscribe(String topicName) async {
    final topics = _topicSubscriptionStream.value;
    final topicSubscription = topics[topicName] ?? MqttSubscriptionState.IDLE;
    if (topicSubscription == MqttSubscriptionState.IDLE) {
      Log.i("Subscription to $topicName doesn't exists. Can't unsubscribe");
      return unit;
    }
    Log.i("Unsubscribing to $topicName");
    _client.unsubscribe(topicName);
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
      Log.i('Publishing message $message to topic $topicName');
      _client.publishMessage(
        topicName,
        MqttQos.exactlyOnce,
        builder.payload,
        retain: true,
      );
      Log.d('Published message $message to topic $topicName');
      return unit;
    } catch (e) {
      throw UnexpectedWriteException();
    }
  }

  @override
  Future<Unit> clear() {
    _client.disconnect();
    _client = null;
    lastMessage.clear();
    return _connectionState
        .firstWhere((element) => element == ServerConnectionState.DISCONNECTED)
        .then((value) => unit);
  }
}

extension on MqttClient {
  MqttConnectionState get state => connectionStatus.state;
}
