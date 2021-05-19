import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/network/api_data_source_interface.dart';
import '../../../domain/network/host_data_source_interface.dart';
import '../../session/session_api.dart';

@LazySingleton(as: IApiDataSource)
class NetworkDataSourceImpl extends IApiDataSource {
  final Dio _dio;
  final IHostDataSource _hostRepository;
  NetworkDataSourceImpl(this._dio, this._hostRepository);

  final Map<String, SessionApi> sessionApiInstances = {};
  final Map<String, UserApi> userApiInstances = {};

  @override
  Future<SessionApi> get sessionApi => _hostRepository.serverUrl.then((value) {
        if (sessionApiInstances[value] == null) {
          sessionApiInstances[value] = SessionApi(_dio, baseUrl: value);
        }
        return sessionApiInstances[value];
      });

  @override
  Future<UserApi> get userApi => _hostRepository.serverUrl.then((value) {
        if (userApiInstances[value] == null) {
          userApiInstances[value] = UserApi(_dio, baseUrl: value);
        }
        return userApiInstances[value];
      });

  @override
  Future<Unit> logout() {
    sessionApiInstances.clear();
    userApiInstances.clear();
    return Future.value(unit);
  }
}
