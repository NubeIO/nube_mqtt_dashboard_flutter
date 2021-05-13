import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) async {
    if (err.response != null) {
      final errorCode = err.response.statusCode;
      if (errorCode >= 500 && errorCode <= 600) {
        return DioError(
            request: err.request,
            error: ServerException(),
            response: err.response);
      } else if (errorCode == 403) {
        return DioError(
            request: err.request,
            error: AuthException(),
            response: err.response);
      } else if (errorCode == 401) {
        return DioError(
            request: err.request,
            error: RefreshException(),
            response: err.response);
      } else if (kReleaseMode) {
        final rawMessage = err.response.data["message"];
        String message = "";
        if (rawMessage is String) {
          message = rawMessage;
        }
        return DioError(
            request: err.request,
            error: message.isEmpty
                ? UnexpectedException()
                : GeneralException(message),
            response: err.response);
      }
    }
    return err;
  }
}
