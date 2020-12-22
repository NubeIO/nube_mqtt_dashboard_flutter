import 'package:dartz/dartz.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IThemeRepository {
  Future<Either<GetThemeFailure, SupportedTheme>> getTheme();

  Stream<Either<GetThemeFailure, SupportedTheme>> getThemeStream();

  Future<Either<SetThemeFailure, Unit>> setTheme(SupportedTheme theme);
}
