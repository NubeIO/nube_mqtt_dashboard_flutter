import 'package:dartz/dartz.dart';

import '../../data/session/session_api.dart';
import '../core/interfaces/datasource.dart';

abstract class IApiDataSource implements IDataSource {
  Future<SessionApi> get sessionApi;

  Future<Unit> logout();
}
