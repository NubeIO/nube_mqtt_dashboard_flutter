import 'entities.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILogDataSource {
  Future<void> addLog(LogItem log);

  Stream<List<LogItem>> get logStream;
}
