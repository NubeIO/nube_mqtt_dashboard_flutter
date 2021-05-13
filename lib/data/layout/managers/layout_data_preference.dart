import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/mqtt/entities.dart';
import '../../mqtt/mappers/topic_message.dart';
import '../../mqtt/models/topic_message_dto.dart';

@injectable
class LayoutPreferenceManager {
  final SharedPreferences _sharedPreferences;
  final _topicMessageMapper = TopicMessageMapper();

  LayoutPreferenceManager(this._sharedPreferences);

  TopicMessage get message {
    final message = _sharedPreferences.getString(_Model.layout.key) ?? "";
    if (message.isEmpty) return null;
    final map = jsonDecode(message) as Map<String, dynamic>;
    return _topicMessageMapper.mapToTopicMesage(TopicMessageDto.fromJson(map));
  }

  set message(TopicMessage message) {
    _sharedPreferences.setString(
      _Model.layout.key,
      jsonEncode(_topicMessageMapper.mapFromTopicMessage(message).toJson()),
    );
  }
}

enum _Model { layout }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.layout:
        return "key:layout:data";
    }
    return "";
  }
}
