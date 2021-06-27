import 'package:dio/dio.dart';

import '../../../domain/events/events_repository_interface.dart';
import '../../../injectable/injection.dart';
import '../exceptions.dart';

class ErrorInterceptor extends Interceptor {
  final IEventsRepository _eventsRepository = getIt<IEventsRepository>();

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
        await _eventsRepository.logout();
        return DioError(
            request: err.request,
            error: RefreshException(),
            response: err.response);
      } else {
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
