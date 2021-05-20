part of failures;

@freezed
abstract class GetTopicFailure extends Failure with _$GetTopicFailure {
  const factory GetTopicFailure.unexpected() = _UnexpectedGetTopic;
  const factory GetTopicFailure.connection() = _ConnectionGetTopic;
  const factory GetTopicFailure.invalidToken() = _InvalidTokenGetTopic;
  const factory GetTopicFailure.server() = _ServerGetTopic;
  const factory GetTopicFailure.general(String message) = _GeneralGetTopic;
}
