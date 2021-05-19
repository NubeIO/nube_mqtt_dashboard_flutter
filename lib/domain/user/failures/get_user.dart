part of failures;

@freezed
abstract class GetUserFailure extends Failure with _$GetUserFailure {
  const factory GetUserFailure.unexpected() = _UnexpectedGetUser;
  const factory GetUserFailure.connection() = _ConnectionUser;
  const factory GetUserFailure.invalidToken() = _InvalidTokenUser;
  const factory GetUserFailure.server() = _ServerUser;
  const factory GetUserFailure.general(String message) = _GeneralUser;
}
