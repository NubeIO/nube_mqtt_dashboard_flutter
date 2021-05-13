part of failures;

@freezed
abstract class LoginUserFailure with _$LoginUserFailure {
  const factory LoginUserFailure.unexpected() = _UnexpectedLogin;
  const factory LoginUserFailure.connection() = _ConnectionLogin;
  const factory LoginUserFailure.server() = _ConnectionLogin;
  const factory LoginUserFailure.general(String message) = _GeneralLogin;
}
