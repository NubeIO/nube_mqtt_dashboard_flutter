part of failures;

@freezed
abstract class ValidatePinFailure extends Failure with _$ValidatePinFailure {
  const factory ValidatePinFailure.invalidPin() = _InvalidPin;
  const factory ValidatePinFailure.unexpected() = _UnexpectedVerifyPin;
}
