import 'package:dartz/dartz.dart';

import 'failures.dart';

export 'failures.dart';

abstract class IHostRepository {
  Future<Either<SetHostFailure, Unit>> setServerDetail(String host, int port);
}
