import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'datasources/models/requests.dart';
import 'datasources/models/responses.dart';

export 'datasources/models/requests.dart';
export 'datasources/models/responses.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET("o/users")
  Future<UserResponse> getUser();

  @POST("o/users/devices")
  Future<DeviceTokenReponse> setDeviceToken(
    @Body() SetDeviceTokenRequest request,
  );

  @POST("users/check/email")
  Future<AvailableResponse> checkEmail(@Body() CheckEmailRequest request);

  @POST("users/check/username")
  Future<AvailableResponse> checkUsername(@Body() CheckUsernameRequest request);
}
