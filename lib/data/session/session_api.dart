import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../core/models/base_response.dart';
import 'datasources/models/requests.dart';
import 'datasources/models/responses.dart';

export 'datasources/models/requests.dart';
export 'datasources/models/responses.dart';

part 'session_api.g.dart';

@RestApi()
abstract class SessionApi {
  factory SessionApi(Dio dio, {String baseUrl}) = _SessionApi;

  @POST("users")
  Future<JWTResponse> registerUser(@Body() RegisterRequest request);

  @POST("users/login")
  Future<JWTResponse> loginUser(@Body() LoginRequest request);

  @POST("um/user")
  Future<BaseResponse> logout();
}
