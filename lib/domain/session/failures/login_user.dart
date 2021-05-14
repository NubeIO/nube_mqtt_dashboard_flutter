part of failures;

@freezed
abstract class LoginUserFailure extends Failure with _$LoginUserFailure {
  const factory LoginUserFailure.unexpected() = _UnexpectedLogin;
  const factory LoginUserFailure.connection() = _ConnectionLogin;
  const factory LoginUserFailure.invalidToken() = _InvalidTokenLogin;
  const factory LoginUserFailure.server() = _ServerLogin;
  const factory LoginUserFailure.general(String message) = _GeneralLogin;
}
