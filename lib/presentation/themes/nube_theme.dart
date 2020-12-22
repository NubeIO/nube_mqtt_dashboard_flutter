import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../domain/theme/entities.dart';
import 'supported_theme/custom_theme.dart';
import 'supported_theme/dark_theme.dart';
import 'supported_theme/default_theme.dart';
import 'theme_interface.dart';

// ignore: avoid_classes_with_only_static_members
@FramyTheme()
class NubeTheme {
  final ITheme theme;

  const NubeTheme([this.theme = const DefaultTheme()]);

  static ITheme map(SupportedTheme theme) {
    return theme.map(
      defaultTheme: (_) => const DefaultTheme(),
      darkTheme: (_) => const DarkTheme(),
      customTheme: (customThemeData) => CustomTheme(customThemeData),
    );
  }

  ThemeData get themeData {
    final colorScheme = ColorScheme(
      primary: theme.primary,
      primaryVariant: theme.primaryDark,
      onPrimary: theme.onPrimary,
      secondary: theme.secondary,
      secondaryVariant: theme.secondaryDark,
      onSecondary: theme.onSecondary,
      background: theme.background,
      onBackground: theme.onBackground,
      error: theme.onError,
      onError: theme.onError,
      surface: theme.surface,
      onSurface: theme.onSurface,
      brightness: theme.brightness,
    );
    return ThemeData(
      scaffoldBackgroundColor: theme.background,
      backgroundColor: theme.background,
      errorColor: theme.error,
      primaryColor: theme.primary,
      primaryColorLight: theme.primaryLight,
      primaryColorDark: theme.primaryDark,
      accentColor: theme.secondary,
      brightness: theme.brightness,
      cardTheme: CardTheme(
        color: _surfaceOverlay(colorScheme),
      ),
      colorScheme: colorScheme,
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      appBarTheme: AppBarTheme(
        brightness: theme.brightness,
        color: theme.background,
        iconTheme: IconThemeData(color: theme.onBackground),
        textTheme: _textTheme,
        elevation: 0,
      ),
      iconTheme: IconThemeData(
        color: theme.onBackground,
      ),
      textTheme: _textTheme,
    );
  }

  static Color surfaceOverlay(BuildContext context, [double elevation = 4]) {
    final colorScheme = Theme.of(context).colorScheme;
    return _surfaceOverlay(colorScheme, elevation);
  }

  static Color _surfaceOverlay(ColorScheme colorScheme,
      [double elevation = 4]) {
    return colorScheme.brightness == Brightness.dark
        ? colorScheme.onSurface.withOpacity(elevationToOverlay(elevation))
        : colorScheme.surface;
  }

  static Color backgroundOverlay(BuildContext context, [double elevation = 4]) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.brightness == Brightness.dark
        ? colorScheme.onBackground.withOpacity(elevationToOverlay(elevation))
        : colorScheme.background;
  }

  static Color colorText200(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.onBackground.withOpacity(.74);
  }

  static Color colorText300(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.onBackground.withOpacity(.66);
  }

  TextTheme get _textTheme => TextTheme(
        headline1: _screenHeading1Style,
        headline2: _screenHeading2Style,
        headline3: _screenHeading3Style,
        headline4: _screenHeading3Style,
        headline5: _screenHeading3Style,
        headline6: _screenHeading3Style,
        subtitle1: _screenSubtitleStyle,
        bodyText1: _screenBodyStyle,
        bodyText2: _screenBody2Style,
        caption: _screenCaptionStyle,
        button: _screenButtonStyle,
        overline: _screenOverlineStyle,
      );

  TextStyle get _screenHeading1Style => TextStyle(
        fontSize: 24,
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        letterSpacing: -0.15,
        height: 1.25,
        color: theme.onBackground,
      );

  TextStyle get _screenHeading2Style => TextStyle(
        fontSize: 17,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.4,
        color: theme.onBackground,
      );

  TextStyle get _screenHeading3Style => TextStyle(
        fontSize: 16,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        height: 1.1,
        color: theme.onBackground,
      );

  TextStyle get _screenSubtitleStyle => TextStyle(
        fontSize: 14,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: theme.onBackground,
      );

  TextStyle get _screenBodyStyle => TextStyle(
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0,
        fontWeight: FontWeight.normal,
        color: theme.onBackground,
      );

  TextStyle get _screenBody2Style => TextStyle(
        fontSize: 14,
        height: 1.5,
        letterSpacing: 0,
        fontWeight: FontWeight.normal,
        color: theme.onBackground,
      );

  TextStyle get _screenCaptionStyle => TextStyle(
        fontSize: 12.0,
        height: 1.16,
        fontWeight: FontWeight.w500,
        color: theme.onBackground.withOpacity(.66),
      );

  TextStyle get _screenButtonStyle => TextStyle(
        fontSize: 16,
        height: 1.5,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: theme.onBackground,
      );

  TextStyle get _screenOverlineStyle => TextStyle(
        fontSize: 10.0,
        height: 1.5,
        letterSpacing: 0,
        fontWeight: FontWeight.normal,
        color: theme.onBackground,
      );
}

double elevationToOverlay(double elevation) {
  if (elevation == 0) {
    return 0;
  } else if (elevation == 1) {
    return 0.05;
  } else if (elevation == 2) {
    return 0.07;
  } else if (elevation == 3) {
    return 0.08;
  } else if (elevation == 4) {
    return 0.09;
  } else if (elevation <= 6) {
    return 0.11;
  } else if (elevation <= 8) {
    return 0.12;
  } else if (elevation <= 12) {
    return 0.14;
  } else if (elevation <= 16) {
    return 0.15;
  } else if (elevation <= 24) {
    return 0.16;
  } else {
    return 0.16;
  }
}
