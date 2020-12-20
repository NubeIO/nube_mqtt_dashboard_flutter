part of failures;

@freezed
abstract class GetPinFailure extends Failure with _$GetPinFailure {
  const factory GetPinFailure.unexpected() = _UnexpectedGetPin;
}
