part of failures;

@freezed
abstract class PasswordFailure extends Failure with _$PasswordFailure {
  const factory PasswordFailure.tooShort() = _TooShort;
  const factory PasswordFailure.noDigit() = _NoDigitPassword;
  const factory PasswordFailure.noUpperChar() = _NoUpperPassword;
  const factory PasswordFailure.passwordMismatch() = _PasswordMismatch;
}
