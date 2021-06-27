part of failures;

@freezed
abstract class RefreshTokenFailure extends Failure with _$RefreshTokenFailure {
  const factory RefreshTokenFailure.unexpected() = _UnexpectedRefreshToken;
  const factory RefreshTokenFailure.refresh() = _FailedRefreshToken;
}
