import '../../../domain/configuration/entities.dart';
import '../datasources/models/responses.dart';

class ConfigurationMapper {
  Configuration toConnectionConfig(
    String deviceId,
    ConnectionConfigResponse response,
  ) {
    return Configuration(
      clientId: deviceId,
      host: response.host,
      port: response.port,
      username: response.username,
      password: response.password,
      authentication: response.authentication,
    );
  }

  TopicConfiguration toTopicConfig(TopicConfigResponse response) {
    return TopicConfiguration(
      alertTopic: response.alertTopic,
      layoutTopic: response.layoutTopic,
    );
  }
}
