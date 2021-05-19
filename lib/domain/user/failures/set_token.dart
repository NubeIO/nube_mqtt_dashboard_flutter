part of failures;

@freezed
abstract class SetTokenFailure extends Failure with _$SetTokenFailure {
  const factory SetTokenFailure.unexpected() = _UnexpectedSetToken;
  const factory SetTokenFailure.connection() = _ConnectionSetToken;
  const factory SetTokenFailure.invalidToken() = _InvalidTokenSetToken;
  const factory SetTokenFailure.server() = _ServerSetToken;
  const factory SetTokenFailure.general(String message) = _GeneralSetToken;
}
