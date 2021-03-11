part of failures;

@freezed
abstract class LogStreamFailure extends Failure with _$LogStreamFailure {
  const factory LogStreamFailure.unknown() = _LogStreamUnknown;
}
