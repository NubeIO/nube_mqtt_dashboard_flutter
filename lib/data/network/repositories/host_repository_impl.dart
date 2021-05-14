import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/network/host_data_source_interface.dart';
import '../../../domain/network/host_repository_interface.dart';

@LazySingleton(as: IHostRepository)
class HostRepositoryImpl extends IHostRepository {
  final IHostDataSource _hostDataSource;
  HostRepositoryImpl(this._hostDataSource);

  @override
  Future<Either<SetHostFailure, Unit>> setServerDetail(String host, int port) {
    return _hostDataSource
        .setServerDetail(host, port)
        .then((value) => const Right(unit));
  }
}
