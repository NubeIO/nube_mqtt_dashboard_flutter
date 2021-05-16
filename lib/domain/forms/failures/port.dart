part of failures;

@freezed
abstract class PortFailure extends Failure with _$PortFailure {
  const factory PortFailure.invalidPort() = _InvalidPort;
  const factory PortFailure.unexpected() = _UnexpectedPort;
  const factory PortFailure.noNumber() = _NotNumber;
}
