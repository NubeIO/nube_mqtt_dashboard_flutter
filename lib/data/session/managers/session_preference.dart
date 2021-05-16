import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/session/entities.dart';

@injectable
class SessionPreferenceManager {
  final SharedPreferences _sharedPreferences;

  SessionPreferenceManager(this._sharedPreferences);

  String get idToken => _sharedPreferences.getString(_Model.idToken.key);
  set idToken(String value) =>
      _sharedPreferences.setString(_Model.idToken.key, value);

  String get refreshToken =>
      _sharedPreferences.getString(_Model.refreshToken.key);
  set refreshToken(String value) =>
      _sharedPreferences.setString(_Model.refreshToken.key, value);

  ProfileStatusType get status =>
      _sharedPreferences.getString(_Model.status.key).toProfileStatus() ??
      ProfileStatusType.LOGGED_OUT;
  set status(ProfileStatusType value) =>
      _sharedPreferences.setString(_Model.status.key, value.name);

  String get token => _sharedPreferences.getString(_Model.token.key);
  set token(String value) =>
      _sharedPreferences.setString(_Model.token.key, value);

  void clearData() {
    _Model.values.forEach(_removeItem);
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { token, status, idToken, refreshToken }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.token:
        return "key:session:token";
      case _Model.status:
        return "key:session:status";
      case _Model.idToken:
        return "key:session:id_token";
      case _Model.refreshToken:
        return "key:session:refresh_token";
    }
    return "";
  }
}

extension on String {
  ProfileStatusType toProfileStatus() =>
      ProfileStatusType.values.firstWhere((element) => element.name == this,
          orElse: () => ProfileStatusType.LOGGED_OUT);
}
