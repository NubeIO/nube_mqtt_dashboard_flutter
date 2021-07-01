import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/configuration/configuration_data_source.dart';
import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/configuration/entities.dart';
import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../domain/site/site_data_source_interface.dart';
import '../../../domain/site/site_repository_interface.dart';
import '../../../utils/logger/log.dart';
import '../managers/configuration_preference.dart';
import '../managers/models/config.dart';
import '../managers/models/topic_config.dart';

const _TAG = "ConfigurationRepository";

@LazySingleton(as: IConfigurationRepository)
class ConfigurationRepositoryImpl extends IConfigurationRepository {
  final ConfigurationPreferenceManager _preferenceManager;
  final IConfigurationDataSource _configurationDataSource;
  final ISiteRepository _siteRepository;

  StreamSubscription<Either<SiteFailure, Site>> activeSubscription;

  ConfigurationRepositoryImpl(
    this._preferenceManager,
    this._configurationDataSource,
    this._siteRepository,
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

  final BehaviorSubject<KtList<SiteAlert>> _alertState = BehaviorSubject()
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
    activeSubscription?.cancel();
    activeSubscription = _siteRepository.activeSiteStream.listen((event) async {
      final topicConfig = _preferenceManager.topicConfig;

      if (topicConfig != null) {
        final currentConfig = await _getCurrentConfig(event);

        _layoutState.add(currentConfig.layoutTopic);
        _alertState.add(topicConfig.entries
            .map((e) => SiteAlert(
                  siteId: e.key,
                  topic: e.value.alertTopic,
                ))
            .toImmutableList());
      }
    });
  }

  @override
  Stream<KtList<SiteAlert>> get alertTopicStream =>
      _alertState.stream.distinct();

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

        await _saveTopics(result);

        final activeSite = await _siteRepository.activeSiteStream.firstWhere(
          (element) => true,
        );

        Log.d("Sites $result", tag: _TAG);
        Log.d("Active Site $activeSite", tag: _TAG);

        final currentConfig = await _getCurrentConfig(activeSite);
        return Right(
          TopicConfiguration(
            layoutTopic: currentConfig.layoutTopic,
            alertTopic: currentConfig.alertTopic,
          ),
        );
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

  Future<Either<SaveFailure, Unit>> _saveTopics(
    Map<String, TopicConfiguration> config,
  ) async {
    try {
      _preferenceManager.topicConfig = config.map(
        (key, value) => MapEntry(
            key,
            TopicConfig(
              alertTopic: value.alertTopic,
              layoutTopic: value.layoutTopic,
            )),
      );
      await _updateTopics();
      return const Right(unit);
    } catch (e) {
      return const Left(SaveFailure.unexpected());
    }
  }

  @override
  Future<Unit> clearData() async {
    await _preferenceManager.clearData();
    return unit;
  }

  Future<TopicConfig> _getCurrentConfig(Either<SiteFailure, Site> event) async {
    final configs = _preferenceManager.topicConfig;
    if (event.isLeft()) {
      return configs.entries.first.value;
    }
    final activeSite = event.fold((l) => throw AssertionError(), id);

    final config = configs.entries
        .firstWhere(
          (element) => element.key == activeSite.uuid,
          orElse: () => configs.entries.first,
        )
        .value;
    return config;
  }
}
