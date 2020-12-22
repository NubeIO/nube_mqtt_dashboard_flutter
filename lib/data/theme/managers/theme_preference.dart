import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/theme/entities.dart';

@injectable
class ThemePreferenceManager {
  final SharedPreferences _sharedPreferences;

  ThemePreferenceManager(this._sharedPreferences);

  SupportedTheme get theme {
    try {
      final config = _sharedPreferences.getString(_Model.theme.key);
      final map = jsonDecode(config) as Map<String, dynamic>;
      return SupportedTheme.fromJson(map);
    } catch (e) {
      return const SupportedTheme.defaultTheme();
    }
  }

  set theme(SupportedTheme value) => _sharedPreferences.setString(
        _Model.theme.key,
        jsonEncode(
          value.toJson(),
        ),
      );
}

enum _Model { theme }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.theme:
        return "key:theme:data";
    }
    return "";
  }
}
