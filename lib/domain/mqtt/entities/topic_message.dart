part of entities;

@freezed
abstract class TopicMessage with _$TopicMessage {
  const factory TopicMessage({
    String topic,
    String message,
  }) = _TopicMessage;
}
