import '../../utils/logger/log_level.dart';
import '../../utils/logger/log_tree.dart';

class ProdLogger extends LogTree {
  @override
  List<LogLevel> getLevels() {
    return [const LogLevel.e()];
  }

  @override
  void log(LogLevel level, String message,
      {String tag, Object ex, StackTrace stacktrace}) {}
}
