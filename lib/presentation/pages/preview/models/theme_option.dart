import 'package:flutter/material.dart';

import '../../../../domain/theme/theme_repository_interface.dart';
import '../../../models/form_options.dart';
import '../../../themes/nube_theme.dart';
import '../../../themes/supported_theme/dark_theme.dart';
import '../../../themes/supported_theme/default_theme.dart';
import '../../../themes/theme_interface.dart';

@immutable
class ThemeOption extends FormOption {
  final ITheme theme;
  final SupportedTheme supportedTheme;

  ThemeOption(this.supportedTheme, this.theme)
      : super(id: theme.runtimeType.toString(), label: theme.name);

  factory ThemeOption.defaultTheme() =>
      ThemeOption(const SupportedTheme.defaultTheme(), const DefaultTheme());
  factory ThemeOption.dark() =>
      ThemeOption(const SupportedTheme.darkTheme(), const DarkTheme());
  factory ThemeOption.custom(CustomThemeData themeData) {
    final supportedTheme = SupportedTheme.customTheme(
      brightness: themeData.brightness,
      primary: themeData.primary,
      primaryLight: themeData.primaryLight,
      primaryDark: themeData.primaryDark,
      secondary: themeData.secondary,
      secondaryLight: themeData.secondaryLight,
      secondaryDark: themeData.secondaryDark,
      background: themeData.background,
      surface: themeData.surface,
      error: themeData.error,
      onPrimary: themeData.onPrimary,
      onSecondary: themeData.onSecondary,
      onBackground: themeData.onBackground,
      onSurface: themeData.onSurface,
      onError: themeData.onError,
    );
    return ThemeOption(supportedTheme, NubeTheme.map(supportedTheme));
  }

  // ignore: prefer_constructors_over_static_methods
  static ThemeOption map(SupportedTheme theme) {
    return theme.map(
        defaultTheme: (_) => ThemeOption.defaultTheme(),
        darkTheme: (_) => ThemeOption.dark(),
        customTheme: (theme) => ThemeOption.custom(theme));
  }
}
