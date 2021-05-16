part of failures;

@freezed
abstract class UsernameFailure extends Failure with _$UsernameFailure {
  const factory UsernameFailure.usernameTaken() = _UsernameTaken;
  const factory UsernameFailure.usernameInvalid() = _InvalidUsername;
}
