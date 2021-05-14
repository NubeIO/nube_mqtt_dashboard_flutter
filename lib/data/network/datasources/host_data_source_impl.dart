import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/network/host_data_source_interface.dart';
import '../exceptions.dart';
import '../managers/host_preference.dart';

@LazySingleton(as: IHostDataSource)
class HostDataSourceImpl extends IHostDataSource {
  final HostPreferenceManager _hostPreferenceManager;
  HostDataSourceImpl(this._hostPreferenceManager);

  @override
  Future<Unit> setServerDetail(
    String host,
    int port,
  ) {
    _hostPreferenceManager.url = "$host:$port";
    return Future.value(unit);
  }

  @override
  Future<String> get serverUrl {
    final _serverUrl = _hostPreferenceManager.url;
    if (_serverUrl.isEmpty) return Future.error(NoHostException());
    return Future.value(_serverUrl);
  }

  @override
  Future<Unit> logout() {
    _hostPreferenceManager.clearData();
    return Future.value(unit);
  }
}
