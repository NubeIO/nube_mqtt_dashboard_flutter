part of 'theme_cubit.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  const factory ThemeState({
    @required SupportedTheme theme,
    @required InternalState<GetThemeFailure> getState,
  }) = _Initial;

  // ignore: prefer_const_constructors
  factory ThemeState.initial() => ThemeState(
        theme: const SupportedTheme.defaultTheme(),
        getState: const InternalState.initial(),
      );
}
