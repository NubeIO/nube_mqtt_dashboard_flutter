import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/configuration/entities.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../utils/logger/log.dart';
import '../managers/configuration_preference.dart';

@LazySingleton(as: IConfigurationRepository)
class ConfigurationRepositoryImpl extends IConfigurationRepository {
  final IMqttRepository _mqttRepository;
  final ConfigurationPreferenceManager _preferenceManager;

  ConfigurationRepositoryImpl(this._mqttRepository, this._preferenceManager);

  @override
  Future<Option<Configuration>> getConfiguration() async {
    if (_preferenceManager.connectionConfig != null) {
      final config = _preferenceManager.connectionConfig;
      Log.d("Restoring configs $config");
      return some(Configuration(
        host: config.host,
        port: config.port,
        clientId: config.clientId,
        username: config.username,
        password: config.password,
      ));
    }
    return none();
  }

  @override
  Future<Either<SaveAndConnectFailure, Unit>> connect({
    String host,
    int port,
    String clientId,
    String username,
    String password,
  }) async {
    try {
      final connectionConfig = ConnectionConfig(
        host: host,
        port: port,
        clientId: clientId,
        username: username,
        password: password,
      );

      _preferenceManager.validity = Validity.INVALID;
      _preferenceManager.connectionConfig = connectionConfig;

      final result = await _mqttRepository.login(connectionConfig);
      return result.fold(
        (failure) => Left(failure.when(
          unexpected: () => const SaveAndConnectFailure.unexpected(),
        )),
        (r) {
          _preferenceManager.validity = Validity.VALID;
          return const Right(unit);
        },
      );
    } catch (e) {
      return const Left(SaveAndConnectFailure.unexpected());
    }
  }
}
