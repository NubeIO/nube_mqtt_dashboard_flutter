import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../constants/app_constants.dart';
import '../../../data/network/dio_error_extension.dart';
import '../../../domain/network/host_data_source_interface.dart';
import '../exceptions.dart';
import '../managers/host_preference.dart';
import '../network_api.dart';

@LazySingleton(as: IHostDataSource)
class HostDataSourceImpl extends IHostDataSource {
  final HostPreferenceManager _hostPreferenceManager;
  final Dio _dio;

  HostDataSourceImpl(
    this._hostPreferenceManager,
    this._dio,
  );

  @override
  Future<Unit> setServerDetail(
    String host,
    int port,
  ) {
    String _host = host;
    // ignore: unnecessary_raw_strings
    if (!host.startsWith(RegExp(r"http?:"))) {
      _host = "http://$host";
    }
    return Future.value("$_host:$port/").then(
      (value) {
        return NetworkApi(_dio, baseUrl: "$value${AppConstants.COMMON_API_URL}")
            .ping()
            .then((_) => value);
      },
    ).then(
      (value) {
        _hostPreferenceManager.url = value;
        return unit;
      },
    ).catchDioException();
  }

  @override
  Future<String> get serverUrl {
    final _serverUrl = _hostPreferenceManager.url;
    if (_serverUrl.isEmpty) return Future.error(NoHostException());
    return Future.value(_serverUrl);
  }

  @override
  Future<Unit> clearData() async {
    await _hostPreferenceManager.clearData();
    return Future.value(unit);
  }
}
