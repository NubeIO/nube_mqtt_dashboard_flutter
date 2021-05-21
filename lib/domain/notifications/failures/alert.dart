part of failures;

@freezed
abstract class AlertFailure extends Failure with _$AlertFailure {
  const factory AlertFailure.invalidAlert() = _InvalidAlert;
  const factory AlertFailure.unexpected() = _UnexpectedAlert;
}
