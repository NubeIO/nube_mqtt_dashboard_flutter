import 'package:dartz/dartz.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IMqttRepository {
  Future<Either<ConnectFailure, Unit>> login(ConnectionConfig mqttConfig);

  Stream<ServerConnectionState> get connectionStream;

  Future<Option<TopicMessage>> getLastTopicMessage(String topicName);

  Stream<TopicMessage> getTopicMessage(String topicName);

  Stream<MqttSubscriptionState> getTopicSubscriptionState(String topicName);

  Future<Unit> subscribe(String topicName);

  Future<Unit> unsubscribe(String topicName);

  Future<Unit> write(String topicName, String message);

  Future<Unit> clear();
}
