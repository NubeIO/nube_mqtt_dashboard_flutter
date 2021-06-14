import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/core/interfaces/managers.dart';

@injectable
class HostPreferenceManager extends IManager {
  final SharedPreferences _sharedPreferences;

  HostPreferenceManager(this._sharedPreferences);

  String get url => _sharedPreferences.getString(_Model.url.key) ?? "";
  set url(String value) => _sharedPreferences.setString(_Model.url.key, value);

  @override
  Future<Unit> clearData() async {
    _Model.values.forEach(_removeItem);
    return unit;
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { url }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.url:
        return "key:host:url";
    }
    return "";
  }
}
