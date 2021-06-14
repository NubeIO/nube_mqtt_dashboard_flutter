import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/network/api_data_source_interface.dart';
import '../../../domain/network/host_data_source_interface.dart';
import '../../../domain/network/host_repository_interface.dart';

@LazySingleton(as: IHostRepository)
class HostRepositoryImpl extends IHostRepository {
  final IHostDataSource _hostDataSource;
  final IApiDataSource _apiDataSource;
  HostRepositoryImpl(this._hostDataSource, this._apiDataSource);

  @override
  Future<Either<SetHostFailure, Unit>> setServerDetail(String host, int port) {
    return _hostDataSource
        .setServerDetail(host, port)
        .then((value) => const Right(unit));
  }

  @override
  Future<Unit> clearData() async {
    await _hostDataSource.clearData();
    await _apiDataSource.clearData();
    return unit;
  }
}
