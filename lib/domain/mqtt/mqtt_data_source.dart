import 'package:dartz/dartz.dart';

import '../configuration/entities.dart';
import '../core/interfaces/datasource.dart';
import 'entities.dart';

export '../configuration/entities.dart';
export 'entities.dart';

abstract class IMqttDataSource implements IDataSource {
  Future<Unit> login(Configuration mqttConfig);

  Stream<ServerConnectionState> get connectionStream;

  Future<Option<TopicMessage>> getLastTopicMessage(String topicName);

  Stream<TopicMessage> getTopicMessage(String topicName);

  Stream<MqttSubscriptionState> getTopicSubscriptionState(String topicName);

  Future<Unit> subscribe(String topicName);

  Future<Unit> unsubscribe(String topicName);

  Future<Unit> write(String topicName, String message);

  Future<Unit> clear();
}
