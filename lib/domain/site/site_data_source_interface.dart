import 'package:kt_dart/kt.dart';

import '../core/interfaces/datasource.dart';
import 'entities.dart';

export 'package:kt_dart/kt.dart';

export 'entities.dart';

abstract class ISiteDataSource implements IDataSource {
  Future<KtList<Site>> getSites();
}
