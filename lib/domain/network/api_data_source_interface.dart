import 'package:dartz/dartz.dart';

import '../../data/session/session_api.dart';

abstract class IApiDataSource {
  Future<SessionApi> get sessionApi;

  Future<Unit> logout();
}
