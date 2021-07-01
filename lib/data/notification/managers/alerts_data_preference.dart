import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/core/interfaces/managers.dart';
import '../models/alerts.dart';

@injectable
class AlertsPreferenceManager extends IManager {
  final SharedPreferences _sharedPreferences;

  AlertsPreferenceManager(this._sharedPreferences);

  Alerts get alerts {
    try {
      final config = _sharedPreferences.getString(_Model.alerts.key);
      final map = jsonDecode(config) as Map<String, dynamic>;
      return Alerts.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  set alerts(Alerts alerts) => _sharedPreferences.setString(
        _Model.alerts.key,
        jsonEncode(
          alerts.toJson(),
        ),
      );

  @override
  Future<Unit> clearData() async {
    _Model.values.forEach(_removeItem);
    return unit;
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { alerts }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.alerts:
        return "key:alerts:data";
    }
    return "";
  }
}
