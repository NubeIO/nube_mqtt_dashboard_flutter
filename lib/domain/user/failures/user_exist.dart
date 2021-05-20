part of failures;

@freezed
abstract class UserExistFailure extends Failure with _$UserExistFailure {
  const factory UserExistFailure.userExists() = _UserExists;
  const factory UserExistFailure.connection() = _ConnectionUserExist;
  const factory UserExistFailure.server() = _ServerUserExist;
  const factory UserExistFailure.unexpected() = _UnexpectedUserExist;
}
