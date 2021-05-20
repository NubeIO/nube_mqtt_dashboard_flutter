part of failures;

@freezed
abstract class UsernameFailure extends Failure with _$UsernameFailure {
  const factory UsernameFailure.usernameTaken() = _UsernameTaken;
  const factory UsernameFailure.usernameInvalid() = _InvalidUsername;
  const factory UsernameFailure.tooShort() = _TooShortUsername;
  const factory UsernameFailure.connection() = _ConnectionUsername;
  const factory UsernameFailure.server() = _ServerUsername;
  const factory UsernameFailure.unexpected() = _UnexpectedUsername;
}
