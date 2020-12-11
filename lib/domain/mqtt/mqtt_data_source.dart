import 'package:dartz/dartz.dart';

import 'entities.dart';

export 'entities.dart';

abstract class IMqttDataSource {
  Future<Unit> login(ConnectionConfig mqttConfig);

  Stream<ServerConnectionState> get connectionStream;

  Future<Option<TopicMessage>> getLastTopicMessage(String topicName);

  Stream<TopicMessage> getTopicMessage(String topicName);

  Stream<MqttSubscriptionState> getTopicSubscriptionState(String topicName);

  Future<Unit> subscribe(String topicName);

  Future<Unit> unsubscribe(String topicName);

  Future<Unit> write(String topicName, String message);

  Future<Unit> clear();
}
