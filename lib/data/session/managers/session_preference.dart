import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_constants.dart';
import '../../../domain/session/session_repository_interface.dart';

@injectable
class SessionPreferenceManager {
  final SharedPreferences _sharedPreferences;

  SessionPreferenceManager(this._sharedPreferences) {
    if (pin.length != AppConstants.PIN_LENGTH) pin = "";
  }

  String get pin => _sharedPreferences.getString(_Model.pin.key) ?? "";
  set pin(String value) => _sharedPreferences.setString(_Model.pin.key, value);

  bool get isUserPinSet =>
      _sharedPreferences.getString(_Model.pin.key)?.isNotEmpty ?? false;

  bool get isAdminPinSet =>
      _sharedPreferences.getString(_Model.adminPin.key)?.isNotEmpty ?? false;

  String get adminPin =>
      _sharedPreferences.getString(_Model.adminPin.key) ?? "";
  set adminPin(String value) =>
      _sharedPreferences.setString(_Model.adminPin.key, value);

  SessionType get status =>
      _sharedPreferences.getString(_Model.status.key).toSessionType() ??
      SessionType.CREATE_PIN;
  set status(SessionType value) =>
      _sharedPreferences.setString(_Model.status.key, value.name);

  void clearData() {
    _Model.values.forEach(_removeItem);
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { status, pin, adminPin }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.status:
        return "key:session:status";
      case _Model.pin:
        return "key:session:pin";
      case _Model.adminPin:
        return "key:session:pin_admin";
    }
    return "";
  }
}

extension on String {
  SessionType toSessionType() =>
      SessionType.values.firstWhere((element) => element.name == this,
          orElse: () => SessionType.CREATE_PIN);
}
