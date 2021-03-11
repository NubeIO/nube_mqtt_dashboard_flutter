import 'package:injectable/injectable.dart';

import '../../domain/log/log_repository_interface.dart';
import '../../utils/logger/log_level.dart';
import '../../utils/logger/log_tree.dart';

@lazySingleton
class ScreenLogger extends LogTree {
  final ILogRepository _logRepository;

  ScreenLogger(this._logRepository);

  @override
  List<LogLevel> getLevels() {
    return [const LogLevel.d(), const LogLevel.e()];
  }

  @override
  void log(
    LogLevel level,
    String message, {
    String tag,
    Object ex,
    StackTrace stacktrace,
  }) {
    _logRepository.addLog(LogItem(
      title: tag,
      message: message,
      detail: "${ex?.toString() ?? ""}\n${stacktrace?.toString() ?? ""}",
      logLevel: level,
      date: DateTime.now(),
    ));
  }
}
