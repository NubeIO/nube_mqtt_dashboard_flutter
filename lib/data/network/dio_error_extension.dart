import 'package:dio/dio.dart';

import 'exceptions.dart';

extension DioErrorExtension<T> on Future<T> {
  Future<T> catchDioException() {
    return catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final error = (obj as DioError).error;
          if (error is NetworkException) {
            throw error;
          }
          throw obj as DioError;
        default:
          throw UnexpectedException();
      }
    });
  }
}
