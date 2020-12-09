import 'package:injectable/injectable.dart';

import '../domain/core/dependencies.dart';
import '../utils/logger/log.dart';
import 'logger/prod_logger.dart';

@Singleton(as: Dependencies, env: [Environment.prod])
class ProdDependencies extends Dependencies {
  @override
  void plantLogTree() {
    Log.plantTree(ProdLogger());
  }
}
