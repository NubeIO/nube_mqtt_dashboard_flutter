import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../core/models/base_response.dart';
import 'datasources/models/requests.dart';
import 'datasources/models/responses.dart';

export 'datasources/models/requests.dart';
export 'datasources/models/responses.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET("um/api/user")
  Future<UserResponse> getUser();

  @POST("um/api/user/devices")
  Future<DeviceTokenReponse> setDeviceToken(
    @Body() SetDeviceTokenRequest request,
  );
}
