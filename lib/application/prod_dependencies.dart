import 'package:injectable/injectable.dart';

import '../domain/core/dependencies.dart';
import '../injectable/injection.dart';
import '../utils/logger/log.dart';
import 'logger/analytics_logger.dart';
import 'logger/log_screen_logger.dart';

@Singleton(as: Dependencies, env: [Environment.prod])
class ProdDependencies extends Dependencies {
  @override
  void plantLogTree() {
    Log.plantTree(getIt<ScreenLogger>());
    Log.plantTree(getIt<AnalyticsLogger>());
  }
}
