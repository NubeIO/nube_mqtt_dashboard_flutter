import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/config.dart';
import 'models/topic_config.dart';

@injectable
class ConfigurationPreferenceManager {
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

  TopicConfig get topicConfig {
    try {
      final config = _sharedPreferences.getString(_Model.topicConfig.key);
      final map = jsonDecode(config) as Map<String, dynamic>;
      return TopicConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  set topicConfig(TopicConfig value) => _sharedPreferences.setString(
        _Model.topicConfig.key,
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
