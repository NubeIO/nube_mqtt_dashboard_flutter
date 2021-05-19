import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../data/network/interceptors/api_headers_interceptor.dart';
import '../../data/network/interceptors/errors.dart';
import '../../data/network/interceptors/http_formatter.dart';
import '../../data/network/interceptors/network_connection.dart';

@module
abstract class NetworkModule {
  DataConnectionChecker get dataConnectionChecker => DataConnectionChecker();

  ErrorInterceptor get errorInterceptor => ErrorInterceptor();

  HttpFormatter get httpFormatter => HttpFormatter();

  Dio getDio(
    NetworkConnectionInterceptor networkConnectionInterceptor,
    ErrorInterceptor errorInterceptor,
    HttpFormatter httpFormatter,
    ApiHeadersInterceptor apiHeaders,
  ) {
    final dio = Dio()
      ..interceptors.add(networkConnectionInterceptor)
      ..interceptors.add(apiHeaders)
      ..interceptors.add(errorInterceptor);
    if (!kReleaseMode) {
      dio.interceptors.add(httpFormatter);
    }
    return dio;
  }
}
