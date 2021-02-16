import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../domain/widget_data/widget_data_repository_interface.dart';
import '../mappers/data.dart';
import '../models/widget_dto.dart';

@LazySingleton(as: IWidgetDataRepository)
class WidgetDataRepositoryImpl extends IWidgetDataRepository {
  final IMqttRepository _mqttRepository;

  WidgetDataRepositoryImpl(this._mqttRepository);

  final dataMapper = DataMapper();

  @override
  Future<Either<SubscribeFailure, Unit>> subscribeWidget(String topic) async {
    try {
      await _mqttRepository.connectionStream
          .firstWhere((element) => element == ServerConnectionState.CONNECTED);
      await _mqttRepository.subscribe(topic);
      return const Right(unit);
    } catch (e) {
      return const Left(SubscribeFailure.unexpected());
    }
  }

  @override
  Stream<Either<SubscriptionStateFailure, MqttSubscriptionState>>
      getSubscriptionState(
    String topic,
  ) {
    return _mqttRepository.getTopicSubscriptionState(topic).asyncMap(
      (message) async {
        try {
          return Right(message);
        } catch (e) {
          return const Left(SubscriptionStateFailure.unexpected());
        }
      },
    );
  }

  @override
  Stream<Either<WidgetDataSubscribeFailure, WidgetData>> getWidgetUpdates(
    String topic,
  ) {
    return _mqttRepository.getTopicMessage(topic).asyncMap((message) =>
        _mapToWidgetData(message).catchError(_onCatchDataException));
  }

  @override
  Future<Either<WidgetSetFailure, Unit>> setData(
    String topic,
    WidgetData value,
  ) async {
    try {
      await _mqttRepository.write(
          topic, jsonEncode(dataMapper.mapToWidgetDataDto(value).toJson()));
      return const Right(unit);
    } catch (e) {
      return const Left(WidgetSetFailure.unexpected());
    }
  }

  Future<Either<WidgetDataSubscribeFailure, WidgetData>> _mapToWidgetData(
    TopicMessage message,
  ) async {
    final layout = jsonDecode(message.message) as Map<String, dynamic>;
    return Right(dataMapper.mapToWidgetData(WidgetDataDto.fromJson(layout)));
  }

  Future<Either<WidgetDataSubscribeFailure, WidgetData>> _onCatchDataException(
    Object error,
  ) async {
    return left(const WidgetDataSubscribeFailure.unexpected());
  }
}
