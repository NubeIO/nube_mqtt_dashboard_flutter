import 'package:flutter/material.dart';

abstract class ITheme {
  String get name;

  Brightness get brightness;

  Color get primary;
  Color get primaryLight;
  Color get primaryDark;
  Color get secondary;
  Color get secondaryLight;
  Color get secondaryDark;
  Color get background;
  Color get surface;
  Color get error;

  Color get onPrimary;
  Color get onSecondary;
  Color get onBackground;
  Color get onSurface;
  Color get onError;
}
