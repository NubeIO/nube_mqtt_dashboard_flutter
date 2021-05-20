part of failures;

@freezed
abstract class EmailFailure extends Failure with _$EmailFailure {
  const factory EmailFailure.invalidEmail() = _InvalidEmail;
  const factory EmailFailure.emailTaken() = _EmailTaken;
  const factory EmailFailure.connection() = _ConnectionEmail;
  const factory EmailFailure.server() = _ServerEmail;
  const factory EmailFailure.unexpected() = _UnexpectedEmail;
}
