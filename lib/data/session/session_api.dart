import 'package:dio/dio.dart';
import 'package:nube_mqtt_dashboard/data/core/models/base_response.dart';
import 'package:retrofit/retrofit.dart';

import 'datasources/models/requests.dart';
import 'datasources/models/responses.dart';

export 'datasources/models/requests.dart';
export 'datasources/models/responses.dart';

part 'session_api.g.dart';

@RestApi()
abstract class SessionApi {
  factory SessionApi(Dio dio, {String baseUrl}) = _SessionApi;

  @POST("user")
  Future<JWTResponse> registerUser(@Body() RegisterRequest request);

  @POST("user")
  Future<JWTResponse> loginUser(@Body() LoginRequest request);

  @POST("user")
  Future<BaseResponse> logout();
}
