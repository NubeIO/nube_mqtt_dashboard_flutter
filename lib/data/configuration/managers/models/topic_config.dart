import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_config.freezed.dart';
part 'topic_config.g.dart';

@freezed
abstract class TopicConfig with _$TopicConfig {
  const factory TopicConfig({
    String layoutTopic,
    String alertTopic,
  }) = _TopicConfig;

  factory TopicConfig.fromJson(Map<String, dynamic> json) =>
      _$TopicConfigFromJson(json);
}
