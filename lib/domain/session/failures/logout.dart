part of failures;

@freezed
abstract class LogoutFailure extends Failure with _$LogoutFailure {
  const factory LogoutFailure.unexpected() = _UnexpectedLogout;
}
