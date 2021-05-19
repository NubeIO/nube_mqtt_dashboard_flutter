import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'datasources/models/responses.dart';

export 'datasources/models/responses.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET("um/api/user")
  Future<UserResponse> getUser();
}
