import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'datasources/models/responses.dart';

export 'datasources/models/requests.dart';
export 'datasources/models/responses.dart';

part 'configuration_api.g.dart';

@RestApi()
abstract class ConfigurationApi {
  factory ConfigurationApi(Dio dio, {String baseUrl}) = _ConfigurationApi;

  @GET("c/mqtt")
  Future<ConnectionConfigResponse> getConnectionConfig();

  @GET("o/users/mqtt")
  Future<Map<String, TopicConfigResponse>> getTopicConfig();
}
