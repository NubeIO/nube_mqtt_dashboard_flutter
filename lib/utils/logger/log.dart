import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'closable_tree.dart';
import 'log_level.dart';
import 'log_tree.dart';

// ignore: avoid_classes_with_only_static_members
class Log {
  static final List<String> _muteLevels = [];

  /// Logs VERBOSE level [message]
  /// with optional exception and stacktrace
  static void v(
    String message, {
    String tag,
    dynamic ex,
    StackTrace stacktrace,
  }) {
    log(const LogLevel.v(), message, tag: tag, ex: ex, stacktrace: stacktrace);
  }

  /// Logs DEBUG level [message]
  /// with optional exception and stacktrace
  static void d(
    String message, {
    @required String tag,
    dynamic ex,
    StackTrace stacktrace,
  }) {
    log(const LogLevel.d(), message, tag: tag, ex: ex, stacktrace: stacktrace);
  }

  /// Logs INFO level [message]
  /// with optional exception and stacktrace
  static void i(
    String message, {
    String tag,
    dynamic ex,
    StackTrace stacktrace,
  }) {
    log(const LogLevel.i(), message, tag: tag, ex: ex, stacktrace: stacktrace);
  }

  /// Logs WARNING level [message]
  /// with optional exception and stacktrace
  static void w(
    String message, {
    @required String tag,
    dynamic ex,
    StackTrace stacktrace,
  }) {
    log(const LogLevel.w(), message, tag: tag, ex: ex, stacktrace: stacktrace);
  }

  /// Logs ERROR level [message]
  /// with optional exception and stacktrace
  static void e(
    String message, {
    @required String tag,
    dynamic ex,
    StackTrace stacktrace,
  }) {
    log(const LogLevel.e(), message, tag: tag, ex: ex, stacktrace: stacktrace);
  }

  /// Mute a log [level] for logging.
  /// Any log entries with the muted log level will be not printed.
  static void mute(String level) {
    if (!_muteLevels.contains(level)) _muteLevels.add(level);
  }

  /// UnMutes a log [level] for logging.
  /// Any log entries with the muted log level will be not printed.
  static void unmute(String level) {
    _muteLevels.removeWhere((it) => it == level);
  }

  /// Logs a [message] with provided [level]
  /// and optional [tag], [ex] and [stacktrace]
  static void log(LogLevel level, String message,
      {String tag, dynamic ex, StackTrace stacktrace}) {
    if (_muteLevels.contains(level)) {
      return; // skip logging if muted.
    }
    final List<LogTree> loggersForTree = _trees[level];
    for (final LogTree logger in loggersForTree ?? []) {
      logger.log(
        level,
        message,
        tag: tag,
        ex: ex,
        stacktrace: stacktrace ??
            (level == const LogLevel.e() ? StackTrace.current : null),
      );
    }
  }

  /// Plant a tree - the source that will receive log messages.
  static void plantTree(LogTree tree) {
    for (final level in tree.getLevels()) {
      List<LogTree> logList = _trees[level];
      if (logList == null) {
        logList = [];
        _trees[level] = logList;
      }
      logList.add(tree);
    }
  }

  /// Un-plants a tree from
  static void unplantTree(LogTree tree) {
    if (tree != null && tree is CloseableTree) {
      (tree as CloseableTree).close();
    }
    _trees.forEach((level, levelTrees) {
      levelTrees.remove(tree);
    });
  }

  /// Clear all trees from Fimber.
  static void clearAll() {
    // un-plant each tree
    _trees.values
        .toSet()
        .fold<List<LogTree>>(<LogTree>[], (buildList, newList) {
          buildList.addAll(newList);
          return buildList;
        })
        .toSet()
        .forEach(unplantTree);
    _trees.clear();
  }

  static final Map<LogLevel, List<LogTree>> _trees = {};
}
