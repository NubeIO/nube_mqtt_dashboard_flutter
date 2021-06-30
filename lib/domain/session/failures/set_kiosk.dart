part of failures;

@freezed
abstract class SetKioskFailure extends Failure with _$SetKioskFailure {
  const factory SetKioskFailure.unexpected() = _UnexpectedSetKiosk;
}
