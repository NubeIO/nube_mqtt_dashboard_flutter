import 'package:dartz/dartz.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ILayoutRepository {
  Stream<Either<LayoutFailure, LayoutBuilder>> get layoutStream;
}
