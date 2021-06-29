import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/core/interfaces/managers.dart';
import 'models/config.dart';
import 'models/topic_config.dart';

@injectable
class ConfigurationPreferenceManager extends IManager {
  final SharedPreferences _sharedPreferences;

  ConfigurationPreferenceManager(this._sharedPreferences);

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

  Map<String, TopicConfig> get topicConfig {
    try {
      final config = _sharedPreferences.getString(_Model.topicConfig.key);
      final map = jsonDecode(config) as Map<String, dynamic>;
      return map.map(
        (k, v) => MapEntry(k, TopicConfig.fromJson(v as Map<String, dynamic>)),
      );
    } catch (e) {
      return null;
    }
  }

  set topicConfig(Map<String, TopicConfig> value) =>
      _sharedPreferences.setString(
        _Model.topicConfig.key,
        jsonEncode(
          value,
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

enum _Model { connectionConfig, topicConfig }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.connectionConfig:
        return "key:configuration:connectionConfig";
      case _Model.topicConfig:
        return "key:configuration:topicConfig";
    }
    return "";
  }
}
