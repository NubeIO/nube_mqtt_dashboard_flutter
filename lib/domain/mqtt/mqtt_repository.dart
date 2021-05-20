import 'package:dartz/dartz.dart';

import '../configuration/entities.dart';
import '../core/interfaces/repository.dart';
import 'entities.dart';
import 'failures.dart';

export '../configuration/entities.dart';
export 'entities.dart';
export 'failures.dart';

abstract class IMqttRepository implements IRepository {
  Future<Either<ConnectFailure, Unit>> login(Configuration mqttConfig);

  Stream<ServerConnectionState> get connectionStream;

  Future<Option<TopicMessage>> getLastTopicMessage(String topicName);

  Stream<TopicMessage> getTopicMessage(String topicName);

  Stream<MqttSubscriptionState> getTopicSubscriptionState(String topicName);

  Future<Unit> subscribe(String topicName);

  Future<Unit> unsubscribe(String topicName);

  Future<Unit> write(String topicName, String message);

  Future<Unit> clear();
}
