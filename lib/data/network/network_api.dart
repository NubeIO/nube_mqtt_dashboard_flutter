import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'network_api.g.dart';

@RestApi()
abstract class NetworkApi {
  factory NetworkApi(Dio dio, {String baseUrl}) = _NetworkApi;

  @GET("/ping")
  Future<HttpResponse<void>> ping();
}
