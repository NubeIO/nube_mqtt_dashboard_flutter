import 'package:dartz/dartz.dart';

import '../core/interfaces/repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IThemeRepository implements IRepository {
  Future<Either<GetThemeFailure, SupportedTheme>> getTheme();

  Stream<Either<GetThemeFailure, SupportedTheme>> getThemeStream();

  Future<Either<SetThemeFailure, Unit>> setTheme(SupportedTheme theme);
}
