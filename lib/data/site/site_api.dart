import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import 'datasources/models/responses.dart';

part 'site_api.g.dart';

@RestApi()
abstract class SiteApi {
  factory SiteApi(Dio dio, {String baseUrl}) = _SiteApi;

  @GET("o/users/sites")
  Future<List<SiteResponse>> getSites();
}
