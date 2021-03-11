import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILogRepository {
  Future<Unit> addLog(LogItem log);

  Stream<Either<LogStreamFailure, KtList<LogItem>>> get logStream;
}
