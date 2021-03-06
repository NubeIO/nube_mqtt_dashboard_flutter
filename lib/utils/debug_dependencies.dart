import 'package:injectable/injectable.dart';

import '../application/logger/log_screen_logger.dart';
import '../domain/core/dependencies.dart';
import '../injectable/injection.dart';
import 'logger/debug_tree.dart';
import 'logger/log.dart';

@Singleton(as: Dependencies, env: [Environment.dev])
class DebugDependencies extends Dependencies {
  @override
  void plantLogTree() {
    Log.plantTree(DebugTree());
    Log.plantTree(getIt<ScreenLogger>());
  }
}
