part of entities;

@freezed
abstract class TopicConfiguration with _$TopicConfiguration {
  const factory TopicConfiguration({
    @required String layoutTopic,
    @required String alertTopic,
  }) = _TopicConfiguration;
}
