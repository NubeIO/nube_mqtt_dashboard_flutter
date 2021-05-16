part of failures;

@freezed
abstract class LengthFailure extends Failure with _$LengthFailure {
  const factory LengthFailure.invalidLength() = _InvalidLength;
}
