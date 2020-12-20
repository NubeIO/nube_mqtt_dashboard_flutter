import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/configuration/entities.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../managers/configuration_preference.dart';

@LazySingleton(as: IConfigurationRepository)
class ConfigurationRepositoryImpl extends IConfigurationRepository {
  final ConfigurationPreferenceManager _preferenceManager;

  ConfigurationRepositoryImpl(this._preferenceManager);

  @override
  Future<Option<Configuration>> getConfiguration() async {
    if (_preferenceManager.connectionConfig != null) {
      final config = _preferenceManager.connectionConfig;
      return some(Configuration(
        host: config.host,
        port: config.port,
        clientId: config.clientId,
        username: config.username,
        password: config.password,
        layoutTopic: config.layoutTopic,
      ));
    }
    return none();
  }

  @override
  Future<Either<SaveFailure, bool>> save({
    String host,
    int port,
    String clientId,
    String username,
    String password,
    String layoutTopic,
  }) async {
    try {
      final prevConfig = _preferenceManager.connectionConfig;
      var shouldReconnect = false;
      if (prevConfig == null) {
        shouldReconnect = true;
      } else if (prevConfig.host != host) {
        shouldReconnect = true;
      } else if (prevConfig.port != port) {
        shouldReconnect = true;
      } else if (prevConfig.layoutTopic != layoutTopic) {
        shouldReconnect = true;
      }

      final connectionConfig = ConnectionConfig(
        host: host,
        port: port,
        clientId: clientId,
        username: username,
        password: password,
        layoutTopic: layoutTopic,
      );

      _preferenceManager.validity = Validity.INVALID;
      _preferenceManager.connectionConfig = connectionConfig;

      return Right(shouldReconnect);
    } catch (e) {
      return const Left(SaveFailure.unexpected());
    }
  }
}
