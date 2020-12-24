import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/core/extensions/option_ext.dart';
import '../../../domain/layout/layout_repository_interface.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../mappers/layout.dart';
import '../models/layout.dart';

@LazySingleton(as: ILayoutRepository)
class LayoutRepositoryImpl extends ILayoutRepository {
  final IMqttRepository _mqttRepository;
  final IConfigurationRepository _configurationRepository;

  LayoutRepositoryImpl(
    this._mqttRepository,
    this._configurationRepository,
  );

  final layoutMapper = LayoutMapper();

  @override
  Future<Either<LayoutSubscribeFailure, Unit>> subscribe() async {
    try {
      final result = await _configurationRepository.getConfiguration();
      if (result.isSome()) {
        final config = result.getOrCrash();
        if (config.layoutTopic.isEmpty) {
          return const Left(LayoutSubscribeFailure.noLayoutConfig());
        }
        await _mqttRepository.login(ConnectionConfig(
          host: config.host,
          port: config.port,
          clientId: config.clientId,
          username: config.username,
          password: config.password,
          layoutTopic: config.layoutTopic,
        ));
        await _mqttRepository.subscribe(config.layoutTopic);
        return const Right(unit);
      } else {
        return const Left(LayoutSubscribeFailure.noLayoutConfig());
      }
    } catch (e) {
      return const Left(LayoutSubscribeFailure.unexpected());
    }
  }

  @override
  Stream<Either<LayoutFailure, LayoutEntity>> get layoutStream async* {
    final result = await _configurationRepository.getConfiguration();
    if (result.isSome()) {
      final config = result.getOrCrash();
      if (config.layoutTopic.isEmpty) {
        yield const Left(LayoutFailure.noLayoutConfig());
      } else {
        yield Right(LayoutEntity.empty());
        yield* _mqttRepository.getTopicMessage(config.layoutTopic).asyncMap(
            (message) =>
                _mapToLayoutBuilder(message).catchError(_onErrorCatch));
      }
    } else {
      yield const Left(LayoutFailure.noLayoutConfig());
    }
  }

  Future<Either<LayoutFailure, LayoutEntity>> _onErrorCatch(
    Object error,
  ) async {
    if (error is FormatException) {
      return left(const LayoutFailure.invalidLayout());
    } else {
      return left(const LayoutFailure.unexpected());
    }
  }

  Future<Either<LayoutFailure, LayoutEntity>> _mapToLayoutBuilder(
    TopicMessage message,
  ) async {
    final layout = jsonDecode(message.message) as Map<String, dynamic>;
    return Right(layoutMapper.mapToBuilder(Layout.fromJson(layout)));
  }
}
