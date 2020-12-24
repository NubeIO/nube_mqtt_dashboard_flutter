part of 'preview_cubit.dart';

@freezed
abstract class PreviewState with _$PreviewState {
  const factory PreviewState({
    @required SupportedTheme theme,
    ValueObject<bool> brightness,
    ValueObject<int> primary,
    ValueObject<int> primaryLight,
    ValueObject<int> primaryDark,
    ValueObject<int> secondary,
    ValueObject<int> secondaryLight,
    ValueObject<int> secondaryDark,
    ValueObject<int> background,
    ValueObject<int> surface,
    ValueObject<int> error,
    ValueObject<int> onPrimary,
    ValueObject<int> onSecondary,
    ValueObject<int> onBackground,
    ValueObject<int> onSurface,
    ValueObject<int> onError,
    @required InternalState<SetThemeFailure> setState,
  }) = _Initial;

  factory PreviewState.initial() {
    const supportedTheme = SupportedTheme.defaultTheme();
    final defaultTheme = NubeTheme.map(supportedTheme);
    return PreviewState(
      theme: supportedTheme,
      brightness:
          ValueObject(some(defaultTheme.brightness == Brightness.light)),
      primary: ValueObject(some(defaultTheme.primary.value)),
      primaryLight: ValueObject(some(defaultTheme.primaryLight.value)),
      primaryDark: ValueObject(some(defaultTheme.primaryDark.value)),
      secondary: ValueObject(some(defaultTheme.secondary.value)),
      secondaryLight: ValueObject(some(defaultTheme.secondaryLight.value)),
      secondaryDark: ValueObject(some(defaultTheme.secondaryDark.value)),
      background: ValueObject(some(defaultTheme.background.value)),
      surface: ValueObject(some(defaultTheme.surface.value)),
      error: ValueObject(some(defaultTheme.error.value)),
      onPrimary: ValueObject(some(defaultTheme.onPrimary.value)),
      onSecondary: ValueObject(some(defaultTheme.onSecondary.value)),
      onBackground: ValueObject(some(defaultTheme.onBackground.value)),
      onSurface: ValueObject(some(defaultTheme.onSurface.value)),
      onError: ValueObject(some(defaultTheme.onError.value)),
      setState: const InternalState.initial(),
    );
  }
}
