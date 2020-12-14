part of failures;

@freezed
abstract class SubscribeFailure extends Failure with _$SubscribeFailure {
  const factory SubscribeFailure.unexpected() = _SubUnexpected;
}
