import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_constants.dart';

@injectable
class PinPreferenceManager {
  final SharedPreferences _sharedPreferences;

  PinPreferenceManager(this._sharedPreferences) {
    if (pin.length != AppConstants.PIN_LENGTH) pin = "";
  }

  String get pin => _sharedPreferences.getString(_Model.pin.key) ?? "";
  set pin(String value) => _sharedPreferences.setString(_Model.pin.key, value);

  bool get isPinSet =>
      _sharedPreferences.getString(_Model.pin.key)?.isNotEmpty ?? false;

  void clearData() {
    _Model.values.forEach(_removeItem);
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { pin }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.pin:
        return "key:session:pin";
    }
    return "";
  }
}
