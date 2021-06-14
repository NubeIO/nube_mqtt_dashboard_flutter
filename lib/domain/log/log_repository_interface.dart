import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';

import '../core/interfaces/data_repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILogRepository extends IDataRepository {
  Future<Unit> addLog(LogItem log);

  Stream<Either<LogStreamFailure, KtList<LogItem>>> get logStream;
}
