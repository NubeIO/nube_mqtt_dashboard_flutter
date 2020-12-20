import 'package:dartz/dartz.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILayoutRepository {
  Future<Either<LayoutSubscribeFailure, Unit>> subscribe();

  Stream<Either<LayoutFailure, LayoutBuilder>> get layoutStream;
}
