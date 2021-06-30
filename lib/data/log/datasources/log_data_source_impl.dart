import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/log/log_data_source_interface.dart';

@LazySingleton(as: ILogDataSource)
class LogDataSource extends ILogDataSource {
  final BehaviorSubject<List<LogItem>> _logStream = BehaviorSubject.seeded([]);

  @override
  Future<void> addLog(LogItem log) async {
    final logs = _logStream.value;
    if (logs.isNotEmpty &&
        logs.first.title == log.title &&
        logs.first.message == log.message &&
        logs.first.date.second == log.date.second) return;

    _logStream.add(logs
      ..insert(0, log)
      ..retainWhere((element) => element.date
          .isAfter(DateTime.now().subtract(const Duration(days: 1)))));
  }

  @override
  Stream<KtList<LogItem>> get logStream =>
      _logStream.stream.map((event) => event.toImmutableList());

  @override
  Future<void> clearData() async {
    _logStream.add([]);
  }
}
