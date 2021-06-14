import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/core/interfaces/managers.dart';
import '../../../domain/mqtt/entities.dart';
import '../../mqtt/mappers/topic_message.dart';
import '../../mqtt/models/topic_message_dto.dart';

@injectable
class AlertsPreferenceManager extends IManager {
  final SharedPreferences _sharedPreferences;
  final _topicMessageMapper = TopicMessageMapper();

  AlertsPreferenceManager(this._sharedPreferences);

  TopicMessage get message {
    final message = _sharedPreferences.getString(_Model.alerts.key) ?? "";
    if (message.isEmpty) return null;
    final map = jsonDecode(message) as Map<String, dynamic>;
    return _topicMessageMapper.mapToTopicMesage(TopicMessageDto.fromJson(map));
  }

  set message(TopicMessage message) {
    _sharedPreferences.setString(
      _Model.alerts.key,
      jsonEncode(_topicMessageMapper.mapFromTopicMessage(message).toJson()),
    );
  }

  @override
  Future<Unit> clearData() async {
    _Model.values.forEach(_removeItem);
    return unit;
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { alerts }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.alerts:
        return "key:alerts:data";
    }
    return "";
  }
}
