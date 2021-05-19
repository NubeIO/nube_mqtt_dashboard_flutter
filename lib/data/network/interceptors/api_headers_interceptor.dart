import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/session/session_repository_interface.dart';
import '../../../injectable/injection.dart';

@injectable
class ApiHeadersInterceptor extends Interceptor {
  ApiHeadersInterceptor();

  ISessionRepository get _sessionRepository => getIt<ISessionRepository>();

  @override
  Future onRequest(RequestOptions options) async {
    final token = await _sessionRepository.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers.addAll({"Authorization": "Bearer $token"});
    }
  }
}
