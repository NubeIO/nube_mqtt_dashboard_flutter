import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nube_mqtt_dashboard/data/mqtt/datasources/mqtt_data_source_impl.dart';
import 'package:nube_mqtt_dashboard/domain/connection/connection_data_source_interface.dart';
import 'package:nube_mqtt_dashboard/domain/mqtt/entities.dart';

import 'package:uuid/uuid.dart';

class ConnectionDataSourceMock extends Mock implements IConnectionDataSource {}

void main() {
  MqttDataSource _mqttDataSource;
  ConnectionConfig _validConfig;
  ConnectionDataSourceMock _connectionDataSourceMock;
  const topicName = "testtopic/ritesh";

  setUp(() {
    _connectionDataSourceMock = ConnectionDataSourceMock();
    when(_connectionDataSourceMock.layoutStream)
        .thenAnswer((_) => const Stream.empty());

    _mqttDataSource = MqttDataSource(_connectionDataSourceMock);
    _validConfig = ConnectionConfig(
      host: "broker.mqttdashboard.com",
      port: 1883,
      clientId: Uuid().v1().toString(),
      username: "",
      password: "",
    );
  });

  test(
    'should connect when provided with correct config',
    () async {
      // arrange
      // act
      final result = await _mqttDataSource.login(_validConfig);
      // assert
      expect(result, equals(unit));
    },
  );

  test(
    'should connect when provided with correct config and emit',
    () async {
      // arrange
      // act
      _mqttDataSource.login(_validConfig);
      // assert
      await expectLater(
        _mqttDataSource.connectionStream,
        emitsThrough(ServerConnectionState.CONNECTED),
      );
    },
  );

  test(
    'should subscribe to a topic when subscribe called',
    () async {
      // arrange
      // act
      await _mqttDataSource.login(_validConfig);
      final result = await _mqttDataSource.subscribe(topicName);
      // assert
      expect(result, equals(unit));

      // _mqttDataSource.write(topicName, message);

      // await expectLater(
      //   _mqttDataSource.getTopicMessage(topicName),
      //   emitsThrough(const TopicMessage(topic: topicName, message: message)),
      // );
    },
  );

  test(
    'should emmit subscription state when subscribe called',
    () async {
      // arrange
      // act
      await _mqttDataSource.login(_validConfig);
      _mqttDataSource.subscribe(topicName);
      // assert
      await expectLater(
        _mqttDataSource.getTopicSubscriptionState(topicName),
        emitsInOrder([
          equals(MqttSubscriptionState.IDLE),
          equals(MqttSubscriptionState.SUBSCRIBED),
        ]),
      );
    },
  );

  test(
    'should emit subscription IDLE when subscribe called on invalid topic',
    () async {
      // arrange
      // act
      await _mqttDataSource.login(_validConfig);
      await _mqttDataSource.subscribe(topicName);
      // assert
      await expectLater(
        _mqttDataSource.getTopicSubscriptionState("Invalid Topic"),
        emits(MqttSubscriptionState.IDLE),
      );
    },
  );

  test(
    'should unsubscribe sucessfully when unsubscribe called',
    () async {
      // arrange
      // act
      await _mqttDataSource.login(_validConfig);
      await _mqttDataSource.subscribe(topicName);

      final result = await _mqttDataSource.unsubscribe(topicName);
      // assert
      expect(result, equals(unit));
    },
  );

  test(
    'should emit subscription IDLE when unsubscribe called',
    () async {
      // arrange
      // act
      await _mqttDataSource.login(_validConfig);
      await _mqttDataSource.subscribe(topicName);

      _mqttDataSource.unsubscribe(topicName);
      // assert
      await expectLater(
        _mqttDataSource.getTopicSubscriptionState(topicName),
        emitsInOrder([
          equals(MqttSubscriptionState.SUBSCRIBED),
          equals(MqttSubscriptionState.IDLE),
        ]),
      );
    },
  );

  test(
    'should clear client sucessfully when clear called',
    () async {
      // arrange
      // act
      await _mqttDataSource.login(_validConfig);
      await _mqttDataSource.subscribe(topicName);

      final result = await _mqttDataSource.unsubscribe(topicName);
      // assert
      expect(result, equals(unit));
    },
  );

  test(
    'should emit subscription IDLE when unsubscribe called',
    () async {
      // arrange
      // act
      await _mqttDataSource.login(_validConfig);
      await _mqttDataSource.subscribe(topicName);

      _mqttDataSource.unsubscribe(topicName);
      // assert
      await expectLater(
        _mqttDataSource.getTopicSubscriptionState(topicName),
        emitsInOrder([
          equals(MqttSubscriptionState.SUBSCRIBED),
          equals(MqttSubscriptionState.IDLE),
        ]),
      );
    },
  );
}
