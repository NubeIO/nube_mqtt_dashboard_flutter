import 'dart:ui';

import '../../../domain/theme/entities.dart';
import '../theme_interface.dart';

class CustomTheme implements ITheme {
  final CustomThemeData _themeData;

  CustomTheme(this._themeData);

  @override
  String get name => "Custom";

  @override
  Brightness get brightness =>
      _themeData.brightness ? Brightness.light : Brightness.dark;

  @override
  Color get background => Color(_themeData.background);

  @override
  Color get surface => Color(_themeData.surface);

  @override
  Color get error => Color(_themeData.error);

  @override
  Color get primary => Color(_themeData.primary);

  @override
  Color get primaryDark => Color(_themeData.primaryDark);

  @override
  Color get primaryLight => Color(_themeData.primaryLight);

  @override
  Color get secondary => Color(_themeData.secondary);

  @override
  Color get secondaryDark => Color(_themeData.secondaryDark);

  @override
  Color get secondaryLight => Color(_themeData.secondaryLight);

  @override
  Color get onBackground => Color(_themeData.onBackground);

  @override
  Color get onSurface => Color(_themeData.onSurface);

  @override
  Color get onError => Color(_themeData.onError);

  @override
  Color get onPrimary => Color(_themeData.onPrimary);

  @override
  Color get onSecondary => Color(_themeData.onSecondary);
}
