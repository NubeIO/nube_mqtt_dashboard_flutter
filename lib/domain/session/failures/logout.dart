part of failures;

@freezed
abstract class LogoutFailure extends Failure with _$LogoutFailure {
  const factory LogoutFailure.unexpected() = _UnexpectedLogout;
  const factory LogoutFailure.connection() = _ConnectionLogout;
  const factory LogoutFailure.server() = _ServerLogout;
  const factory LogoutFailure.general(String message) = _GeneralLogout;
}
