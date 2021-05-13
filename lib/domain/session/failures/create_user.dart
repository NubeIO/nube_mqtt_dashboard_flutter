part of failures;

@freezed
abstract class CreateUserFailure with _$CreateUserFailure {
  const factory CreateUserFailure.unexpected() = _UnexpectedCreateUser;
  const factory CreateUserFailure.connection() = _ConnectionCreateUser;
  const factory CreateUserFailure.server() = _ServerCreateUser;
  const factory CreateUserFailure.general(String message) = _GeneralCreateUser;
}
