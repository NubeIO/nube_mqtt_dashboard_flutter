import 'package:dartz/dartz.dart';

import '../core/interfaces/repository.dart';
import 'failures.dart';

export 'failures.dart';

abstract class IHostRepository implements IRepository {
  Future<Either<SetHostFailure, Unit>> setServerDetail(String host, int port);
}
