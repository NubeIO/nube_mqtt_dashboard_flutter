import 'package:dartz/dartz.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILayoutRepository {
  Future<Either<LayoutFailure, LayoutEntity>> getPersistantLayout();

  Future<Either<LayoutSubscribeFailure, Unit>> subscribe();

  Stream<Either<LayoutFailure, LayoutEntity>> get layoutStream;
}
