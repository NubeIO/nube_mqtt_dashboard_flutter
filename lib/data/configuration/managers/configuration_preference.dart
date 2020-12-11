import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/mqtt/mqtt_repository.dart';

@injectable
class ConfigurationPreferenceManager {
  final SharedPreferences _sharedPreferences;

  ConfigurationPreferenceManager(this._sharedPreferences);

  set validity(Validity value) =>
      _sharedPreferences.setString(_Model.isValid.key, value.name);
  Validity get validity =>
      _sharedPreferences.getString(_Model.isValid.key).toValidity() ??
      Validity.INVALID;

  ConnectionConfig get connectionConfig {
    try {
      final config = _sharedPreferences.getString(_Model.connectionConfig.key);
      final map = jsonDecode(config) as Map<String, dynamic>;
      return ConnectionConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  set connectionConfig(ConnectionConfig value) => _sharedPreferences.setString(
        _Model.connectionConfig.key,
        jsonEncode(
          value.toJson(),
        ),
      );

  void clearData() {
    _Model.values.forEach(_removeItem);
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { isValid, connectionConfig }
enum Validity { VALID, INVALID }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.isValid:
        return "key:configuration:isValid";

      case _Model.connectionConfig:
        return "key:configuration:connectionConfig";
    }
    return "";
  }
}

extension ValidityExtension on Validity {
  String get name => toString();
}

extension on String {
  Validity toValidity() =>
      Validity.values.firstWhere((element) => element.name == this,
          orElse: () => Validity.INVALID);
}
