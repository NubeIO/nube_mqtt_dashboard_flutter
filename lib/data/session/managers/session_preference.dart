import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/core/interfaces/managers.dart';
import '../../../domain/session/entities.dart';

@injectable
class SessionPreferenceManager extends IManager {
  final SharedPreferences _sharedPreferences;

  SessionPreferenceManager(this._sharedPreferences);

  String get accessToken =>
      _sharedPreferences.getString(_Model.accessToken.key);
  set accessToken(String value) =>
      _sharedPreferences.setString(_Model.accessToken.key, value);

  ProfileStatusType get status =>
      _sharedPreferences.getString(_Model.status.key).toProfileStatus() ??
      ProfileStatusType.LOGGED_OUT;
  set status(ProfileStatusType value) =>
      _sharedPreferences.setString(_Model.status.key, value.name);

  String get tokenType => _sharedPreferences.getString(_Model.tokenType.key);
  set tokenType(String value) =>
      _sharedPreferences.setString(_Model.tokenType.key, value);

  @override
  Future<Unit> clearData() async {
    _Model.values.forEach(_removeItem);
    return unit;
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model {
  accessToken,
  status,
  tokenType,
}

extension on _Model {
  String get key {
    switch (this) {
      case _Model.accessToken:
        return "key:session:accessToken";
      case _Model.status:
        return "key:session:status";
      case _Model.tokenType:
        return "key:session:tokenType";
    }
    return "";
  }
}

extension on String {
  ProfileStatusType toProfileStatus() =>
      ProfileStatusType.values.firstWhere((element) => element.name == this,
          orElse: () => ProfileStatusType.LOGGED_OUT);
}
