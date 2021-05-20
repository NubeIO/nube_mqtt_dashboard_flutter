import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/configuration/configuration_data_source.dart';
import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/configuration/entities.dart';
import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../utils/logger/log.dart';
import '../managers/configuration_preference.dart';
import '../managers/models/config.dart';
import '../managers/models/topic_config.dart';

const _TAG = "ConfigurationRepository";

@LazySingleton(as: IConfigurationRepository)
class ConfigurationRepositoryImpl extends IConfigurationRepository {
  final ConfigurationPreferenceManager _preferenceManager;
  final IConfigurationDataSource _configurationDataSource;

  ConfigurationRepositoryImpl(
    this._preferenceManager,
    this._configurationDataSource,
  ) {
    _updateConfiguration();
    _updateTopics();
  }

  final BehaviorSubject<Configuration> _connectionState = BehaviorSubject()
    ..listen((event) {
      Log.i("Config $event", tag: _TAG);
    });

  final BehaviorSubject<String> _layoutState = BehaviorSubject()
    ..listen((event) {
      Log.i("Layout $event", tag: _TAG);
    });

  final BehaviorSubject<String> _alertState = BehaviorSubject()
    ..listen((event) {
      Log.i("Alert $event", tag: _TAG);
    });

  Future<void> _updateConfiguration() async {
    if (_preferenceManager.connectionConfig != null) {
      final config = _preferenceManager.connectionConfig;
      _connectionState.add(Configuration(
        host: config.host,
        port: config.port,
        clientId: config.clientId,
        username: config.username,
        password: config.password,
        authentication: config.authentication,
      ));
    }
  }

  Future<void> _updateTopics() async {
    if (_preferenceManager.topicConfig != null) {
      final config = _preferenceManager.topicConfig;
      _layoutState.add(config.layoutTopic);
      _alertState.add(config.alertTopic);
    }
  }

  @override
  Stream<String> get alertTopicStream => _alertState.stream.distinct();

  @override
  Stream<Configuration> get configurationStream =>
      _connectionState.stream.distinct();

  @override
  Stream<String> get layoutTopicStream => _layoutState.stream.distinct();

  @override
  Future<Either<GetConnectionFailure, Configuration>> fetchConnectionConfig() {
    return futureFailureHelper(
      request: () async {
        final result = await _configurationDataSource.fetchConnectionConfig();
        await save(
          host: result.host,
          port: result.port,
          password: result.password,
          username: result.username,
          clientId: result.clientId,
        );
        return Right(result);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const GetConnectionFailure.connection(),
        general: (message) => GetConnectionFailure.general(message),
        orElse: () => const GetConnectionFailure.server(),
      ),
    );
  }

  @override
  Future<Either<GetTopicFailure, TopicConfiguration>> fetchTopicConfig() {
    return futureFailureHelper(
      request: () async {
        final result = await _configurationDataSource.fetchTopicConfig();
        await saveTopics(
          alertTopic: result.alertTopic,
          layoutTopic: result.layoutTopic,
        );
        return Right(result);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const GetTopicFailure.connection(),
        general: (message) => GetTopicFailure.general(message),
        orElse: () => const GetTopicFailure.server(),
      ),
    );
  }

  @override
  Future<Either<SaveFailure, Unit>> save({
    @required String host,
    @required int port,
    @required String clientId,
    @required String username,
    @required String password,
  }) async {
    try {
      final connectionConfig = ConnectionConfig(
        host: host,
        port: port,
        clientId: clientId,
        username: username,
        password: password,
      );

      await _updateConfiguration();

      _preferenceManager.connectionConfig = connectionConfig;

      return const Right(unit);
    } catch (e) {
      return const Left(SaveFailure.unexpected());
    }
  }

  @override
  Future<Either<SaveFailure, Unit>> saveTopics({
    @required String layoutTopic,
    @required String alertTopic,
  }) async {
    try {
      final topicConfig = TopicConfig(
        layoutTopic: layoutTopic,
        alertTopic: alertTopic,
      );

      _preferenceManager.topicConfig = topicConfig;
      await _updateTopics();
      return const Right(unit);
    } catch (e) {
      return const Left(SaveFailure.unexpected());
    }
  }
}
