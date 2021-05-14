import 'package:dartz/dartz.dart';

import '../core/interfaces/datasource.dart';

abstract class IHostDataSource implements IDataSource {
  Future<Unit> setServerDetail(String host, int port);

  Future<String> get serverUrl;

  Future<Unit> logout();
}
