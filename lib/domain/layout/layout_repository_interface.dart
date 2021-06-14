import 'package:dartz/dartz.dart';

import '../core/interfaces/data_repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILayoutRepository implements IDataRepository {
  Stream<Either<LayoutFailure, LayoutEntity>> get layoutStream;
}
