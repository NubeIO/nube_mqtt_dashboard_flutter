import 'package:injectable/injectable.dart';

import '../../utils/logger/log_level.dart';
import '../../utils/logger/log_tree.dart';

@lazySingleton
class AnalyticsLogger extends LogTree {
  @override
  List<LogLevel> getLevels() {
    return [const LogLevel.i(), const LogLevel.d(), const LogLevel.e()];
  }

  @override
  void log(
    LogLevel level,
    String message, {
    String tag,
    Object ex,
    StackTrace stacktrace,
  }) {}
}
