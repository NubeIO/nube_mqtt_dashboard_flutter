import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme_interface.dart';

class DefaultTheme implements ITheme {
  const DefaultTheme();

  @override
  String get name => "Nube";

  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get background => Colors.white;

  @override
  Color get surface => Colors.white;

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
  Color get error => const Color(0xFFB00020);

  @override
  Color get onBackground => Colors.black;

  @override
  Color get onSurface => Colors.black;

  @override
  Color get onError => Colors.white;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get onSecondary => Colors.white;
}
