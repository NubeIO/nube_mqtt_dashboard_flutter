part of entities;

@Freezed(unionKey: "type")
abstract class SupportedTheme with _$SupportedTheme {
  const factory SupportedTheme.defaultTheme() = _Default;
  const factory SupportedTheme.darkTheme() = _DarkTheme;

  const factory SupportedTheme.customTheme({
    @required bool brightness,
    @required int primary,
    @required int primaryLight,
    @required int primaryDark,
    @required int secondary,
    @required int secondaryLight,
    @required int secondaryDark,
    @required int background,
    @required int surface,
    @required int error,
    @required int onPrimary,
    @required int onSecondary,
    @required int onBackground,
    @required int onSurface,
    @required int onError,
  }) = CustomThemeData;

  factory SupportedTheme.fromJson(Map<String, dynamic> json) =>
      _$SupportedThemeFromJson(json);
}
