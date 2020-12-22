import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme_interface.dart';

class DarkTheme implements ITheme {
  const DarkTheme();

  @override
  String get name => "Nube Dark";

  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get background => const Color(0xFF121212);

  @override
  Color get surface => const Color(0xFF121212);

  @override
  Color get error => const Color(0xFFCF6679);

  @override
  Color get primary => const Color(0xFF339999);

  @override
  Color get primaryDark => const Color(0xFF297a7a);

  @override
  Color get primaryLight => const Color(0xFF70b8b8);

  @override
  Color get secondary => const Color(0xFFFBB93E);

  @override
  Color get secondaryDark => const Color(0xFFc99432);

  @override
  Color get secondaryLight => const Color(0xFFfcce78);

  @override
  Color get onBackground => Colors.white;

  @override
  Color get onSurface => Colors.white;

  @override
  Color get onError => Colors.black;

  @override
  Color get onPrimary => Colors.black;

  @override
  Color get onSecondary => Colors.black;
}
