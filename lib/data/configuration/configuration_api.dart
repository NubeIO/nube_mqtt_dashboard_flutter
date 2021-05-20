import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'datasources/models/responses.dart';

export 'datasources/models/requests.dart';
export 'datasources/models/responses.dart';

part 'configuration_api.g.dart';

@RestApi()
abstract class ConfigurationApi {
  factory ConfigurationApi(Dio dio, {String baseUrl}) = _ConfigurationApi;

  @GET("api/mrb_listener")
  Future<ConnectionConfigResponse> getConnectionConfig();

  @GET("um/api/mqtt/topics")
  Future<TopicConfigResponse> getTopicConfig();
}
