import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../domain/theme/theme_repository_interface.dart';
import '../managers/theme_preference.dart';

@LazySingleton(as: IThemeRepository)
class ThemeRepositoryImpl extends IThemeRepository {
  final ThemePreferenceManager _themePreferenceManager;
  final BehaviorSubject<SupportedTheme> themeStream = BehaviorSubject();

  ThemeRepositoryImpl(this._themePreferenceManager) {
    _initTheme();
  }

  Future<void> _initTheme() async {
    (await getTheme()).fold((l) => null, (theme) => themeStream.add(theme));
  }

  @override
  Future<Either<GetThemeFailure, SupportedTheme>> getTheme() async {
    try {
      return Right(_themePreferenceManager.theme);
    } catch (e) {
      return const Left(GetThemeFailure.unexpected());
    }
  }

  @override
  Stream<Either<GetThemeFailure, SupportedTheme>> getThemeStream() {
    return themeStream.stream
        .asyncMap((event) => _mapTheme(event).catchError(_onErrorCatch));
  }

  Future<Either<GetThemeFailure, SupportedTheme>> _mapTheme(
          SupportedTheme supportedTheme) async =>
      Right(supportedTheme);

  @override
  Future<Either<SetThemeFailure, Unit>> setTheme(SupportedTheme theme) async {
    try {
      _themePreferenceManager.theme = theme;
      themeStream.add(theme);
      return const Right(unit);
    } catch (e) {
      return const Left(SetThemeFailure.unexpected());
    }
  }

  Future<Either<GetThemeFailure, SupportedTheme>> _onErrorCatch(
    Object error,
  ) async {
    return left(const GetThemeFailure.unexpected());
  }
}
