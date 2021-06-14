import 'package:dartz/dartz.dart';

import '../core/interfaces/data_repository.dart';
import 'failures.dart';

export 'failures.dart';

abstract class IHostRepository implements IDataRepository {
  Future<Either<SetHostFailure, Unit>> setServerDetail(String host, int port);
}
