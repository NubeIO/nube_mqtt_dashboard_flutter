import 'package:kt_dart/kt.dart';

import '../core/interfaces/datasource.dart';
import 'entities.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILogDataSource extends IDataSource {
  Future<void> addLog(LogItem log);

  Stream<KtList<LogItem>> get logStream;

  Future<void> clearData();
}
