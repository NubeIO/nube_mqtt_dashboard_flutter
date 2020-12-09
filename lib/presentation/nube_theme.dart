import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

// ignore: avoid_classes_with_only_static_members
@FramyTheme()
class NubeTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: lightScaffoldBackgroundColor,
        errorColor: lightErrorColor,
        primaryColor: lightPrimaryColor,
        primaryColorLight: lightPrimaryLightColor,
        primaryColorDark: lightPrimaryDarkColor,
        accentColor: lightSecondaryColor,
        toggleableActiveColor: lightSecondaryColor,
        colorScheme: const ColorScheme.light(
            primary: lightPrimaryColor,
            secondary: lightSecondaryColor,
            onPrimary: lightOnPrimaryColor,
            error: lightErrorColor,
            onSecondary: lightonSecondaryColor),
        appBarTheme: const AppBarTheme(
          brightness: Brightness.light,
          color: lightScaffoldBackgroundColor,
          iconTheme: IconThemeData(color: lightOnPrimaryColor),
          textTheme: _lightTextTheme,
          elevation: 0,
        ),
        iconTheme: const IconThemeData(
          color: iconColor,
        ),
        textTheme: _lightTextTheme,
      );

  static const TextTheme _lightTextTheme = TextTheme(
    headline1: _lightScreenHeading1Style,
    headline2: _lightScreenHeading2Style,
    headline3: _lightScreenHeading3Style,
    headline4: _lightScreenHeading3Style,
    headline5: _lightScreenHeading3Style,
    headline6: _lightScreenHeading3Style,
    subtitle1: _lightScreenSubtitleStyle,
    bodyText1: _lightScreenBodyStyle,
    bodyText2: _lightScreenBody2Style,
    caption: _lightScreenCaptionStyle,
    button: _lightScreenButtonStyle,
    overline: _lightScreenOverlineStyle,
  );

  static const Color lightScaffoldBackgroundColor = Colors.white;

  static const Color iconColor = Colors.black;
  static const Color lightErrorColor = Color(0xfff8473a);

  static const Color lightSecondaryColor = Color(0xFF3BCEAC);
  static const Color lightSecondaryLightColor = Color(0xFF77ffde);
  static const Color lightSecondaryDarkColor = Color(0xFF009c7d);

  static const Color lightPrimaryColor = Color(0xFF12355b);
  static const Color lightPrimaryLightColor = Color(0xFF435e88);
  static const Color lightPrimaryDarkColor = Color(0xFF000e31);

  static const Color lightColorText300 = Color(0xFF686D78);
  static const Color lightColorText200 = Color(0xFFB8BBC1);
  static const Color lightColorText100 = Color(0xFFF9F9F9);
  static const Color lightColorBorder = Color(0xFFEFEFF1);

  static const Color lightOnPrimaryColor = Colors.black;
  static const Color lightonSecondaryColor = Colors.white;
  static const TextStyle _lightScreenHeading1Style = TextStyle(
    fontSize: 24,
    fontFamily: "Poppins",
    fontWeight: FontWeight.bold,
    letterSpacing: -0.15,
    height: 1.25,
    color: lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenHeading2Style = TextStyle(
    fontSize: 17,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
    color: lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenHeading3Style = TextStyle(
    fontSize: 16,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenSubtitleStyle = TextStyle(
    fontSize: 14,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenBodyStyle = TextStyle(
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenBody2Style = TextStyle(
    fontSize: 14,
    height: 1.5,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenCaptionStyle = TextStyle(
    fontSize: 12.0,
    height: 1.16,
    fontWeight: FontWeight.w500,
    color: lightColorText300,
  );

  static const TextStyle _lightScreenButtonStyle = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
    color: lightOnPrimaryColor,
  );

  static const TextStyle _lightScreenOverlineStyle = TextStyle(
    fontSize: 10.0,
    height: 1.5,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: lightOnPrimaryColor,
  );
}
