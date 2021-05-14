import 'package:dartz/dartz.dart';

abstract class IHostDataSource {
  Future<Unit> setServerDetail(String host, int port);

  Future<String> get serverUrl;

  Future<Unit> logout();
}
