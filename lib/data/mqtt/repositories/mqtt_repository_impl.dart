import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/mqtt/mqtt_data_source.dart';
import '../../../domain/mqtt/mqtt_repository.dart';

@LazySingleton(as: IMqttRepository)
class MqttRepositoryImpl extends IMqttRepository {
  final IMqttDataSource _mqttDataSource;
  MqttRepositoryImpl(this._mqttDataSource);

  @override
  Future<Either<ConnectFailure, Unit>> login(
      ConnectionConfig mqttConfig) async {
    try {
      await _mqttDataSource.login(mqttConfig);
      return const Right(unit);
    } catch (e) {
      return const Left(ConnectFailure.unexpected());
    }
  }

  @override
  Future<Unit> clear() {
    return _mqttDataSource.clear();
  }

  @override
  Stream<ServerConnectionState> get connectionStream =>
      _mqttDataSource.connectionStream;

  @override
  Future<Option<TopicMessage>> getLastTopicMessage(String topicName) =>
      _mqttDataSource.getLastTopicMessage(topicName);

  @override
  Stream<TopicMessage> getTopicMessage(String topicName) {
    return _mqttDataSource.getTopicMessage(topicName);
  }

  @override
  Stream<MqttSubscriptionState> getTopicSubscriptionState(String topicName) {
    return _mqttDataSource.getTopicSubscriptionState(topicName);
  }

  @override
  Future<Unit> subscribe(String topicName) {
    return _mqttDataSource.subscribe(topicName);
  }

  @override
  Future<Unit> unsubscribe(String topicName) {
    return _mqttDataSource.unsubscribe(topicName);
  }

  @override
  Future<Unit> write(String topicName, String message) {
    return _mqttDataSource.write(topicName, message);
  }
}
