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

  final Map<String, SessionApi> instances = {};

  @override
  Future<SessionApi> get sessionApi => _hostRepository.serverUrl.then((value) {
        if (instances[value] == null) {
          instances[value] = SessionApi(_dio, baseUrl: value);
        }
        return instances[value];
      });

  @override
  Future<Unit> logout() {
    instances.clear();
    return Future.value(unit);
  }
}
