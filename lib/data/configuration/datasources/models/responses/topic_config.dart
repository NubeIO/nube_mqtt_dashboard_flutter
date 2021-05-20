part of responses;

@freezed
abstract class TopicConfigResponse with _$TopicConfigResponse {
  const factory TopicConfigResponse({
    @JsonKey(name: "layout_topic") String layoutTopic,
    @JsonKey(name: "alert_topic") String alertTopic,
  }) = _TopicConfigResponse;

  factory TopicConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$TopicConfigResponseFromJson(json);
}
