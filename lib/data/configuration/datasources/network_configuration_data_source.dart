import 'package:injectable/injectable.dart';

import '../../../data/network/dio_error_extension.dart';
import '../../../domain/configuration/configuration_data_source.dart';
import '../../../domain/network/api_data_source_interface.dart';
import '../../../domain/notifications/notification_data_source_interface.dart';
import '../mapper/configuration.dart';

@LazySingleton(as: IConfigurationDataSource)
class NetworkConfigurationDataSource extends IConfigurationDataSource {
  final IApiDataSource _apiRepository;
  final INotificationDataSource _notificationDataSource;

  NetworkConfigurationDataSource(
      this._apiRepository, this._notificationDataSource);

  final configurationMapper = ConfigurationMapper();

  @override
  Future<Configuration> fetchConnectionConfig() async {
    final token = await _notificationDataSource.getToken();
    return _apiRepository.configurationApi
        .then((api) => api.getConnectionConfig())
        .then((response) =>
            configurationMapper.toConnectionConfig(token, response))
        .catchDioException();
  }

  @override
  Future<Map<String, TopicConfiguration>> fetchTopicConfig() {
    return _apiRepository.configurationApi
        .then((api) => api.getTopicConfig())
        .then((map) => map.map(
              (id, config) => MapEntry(
                id,
                configurationMapper.toTopicConfig(config),
              ),
            ))
        .catchDioException();
  }
}
