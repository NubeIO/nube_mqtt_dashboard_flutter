import 'package:dio/dio.dart';

import '../../utils/logger/log.dart';
import 'exceptions.dart';

extension DioErrorExtension<T> on Future<T> {
  Future<T> catchDioException() {
    return catchError((Object obj) {
      Log.e(obj.toString(), ex: obj, tag: "DioErrorExtension");
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
