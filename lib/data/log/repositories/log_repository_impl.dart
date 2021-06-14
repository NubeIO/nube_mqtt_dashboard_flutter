import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

import '../../../domain/log/log_data_source_interface.dart';
import '../../../domain/log/log_repository_interface.dart';

@LazySingleton(as: ILogRepository)
class LogRepositoryImpl extends ILogRepository {
  final ILogDataSource _logDataSource;

  LogRepositoryImpl(this._logDataSource);

  @override
  Future<Unit> addLog(LogItem log) async {
    try {
      await _logDataSource.addLog(log);
      // ignore: empty_catches
    } catch (e) {}
    return unit;
  }

  @override
  Stream<Either<LogStreamFailure, KtList<LogItem>>> get logStream async* {
    yield* _logDataSource.logStream
        .handleError(() => const Left(LogStreamFailure.unknown()))
        .map((event) => Right(event.toImmutableList()));
  }

  @override
  Future<Unit> clearData() async {
    await _logDataSource.clearData();
    return unit;
  }
}
