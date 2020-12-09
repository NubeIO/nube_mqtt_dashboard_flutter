import 'log_level.dart';

/// Interface for LogTree
abstract class LogTree {
  static const String _defaultTag = "Flutter";

  /// Logs [message] with log [level]
  /// and optional [tag], [ex] (exception) [stacktrace]
  void log(LogLevel level, String message,
      {String tag, dynamic ex, StackTrace stacktrace});

  /// Gets levels of logging serviced by this [LogTree]
  List<LogLevel> getLevels();

  /// Gets tag with [stackIndex],
  /// how many steps in stacktrace should be taken to grab log call.
  static String getTag({int stackIndex = 4}) {
    final stackTraceList = StackTrace.current.toString().split('\n');
    if (stackTraceList.length > stackIndex) {
      final lineChunks =
          stackTraceList[stackIndex].replaceAll("<anonymous closure>", "<ac>");
      if (lineChunks.length > 6) {
        final lineParts = lineChunks.split(' ');
        if (lineParts.length > 8 && lineParts[6] == 'new') {
          // constructor logging
          return "${lineParts[6]} ${lineParts[7]}";
        } else if (lineParts.length > 6) {
          return lineParts[6] ?? _defaultTag; // need better error handling
        } else {
          return _defaultTag;
        }
      } else {
        return _defaultTag;
      }
    } else {
      return _defaultTag; //default
    }
  }

  /// Gets tag with [stackIndex]
  /// how many steps in stacktrace should be taken to grab log call.
  static List<String> getStacktrace({int stackIndex = 6}) {
    final stackTraceList = StackTrace.current.toString().split('\n');
    return stackTraceList.sublist(stackIndex);
  }
}
