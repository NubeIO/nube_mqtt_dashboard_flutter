import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class HostPreferenceManager {
  final SharedPreferences _sharedPreferences;

  HostPreferenceManager(this._sharedPreferences);

  String get url => _sharedPreferences.getString(_Model.url.key) ?? "";
  set url(String value) => _sharedPreferences.setString(_Model.url.key, value);

  void clearData() {
    _Model.values.forEach(_removeItem);
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
