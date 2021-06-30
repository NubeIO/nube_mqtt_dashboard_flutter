import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_constants.dart';
import '../../../domain/core/interfaces/managers.dart';

@injectable
class PinPreferenceManager extends IManager {
  final SharedPreferences _sharedPreferences;

  PinPreferenceManager(this._sharedPreferences) {
    if (pin.length != AppConstants.PIN_LENGTH) pin = "";
  }

  String get pin => _sharedPreferences.getString(_Model.pin.key) ?? "";
  set pin(String value) => _sharedPreferences.setString(_Model.pin.key, value);

  bool get isKioskMode => _sharedPreferences.getBool(_Model.kiosk.key) ?? false;
  set isKioskMode(bool value) =>
      _sharedPreferences.setBool(_Model.kiosk.key, value);

  bool get isPinSet =>
      _sharedPreferences.getString(_Model.pin.key)?.isNotEmpty ?? false;

  @override
  Future<Unit> clearData() async {
    _Model.values.forEach(_removeItem);
    return unit;
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { pin, kiosk }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.pin:
        return "key:session:pin";
      case _Model.kiosk:
        return "key:session:kiosk";
    }
    return "";
  }
}
