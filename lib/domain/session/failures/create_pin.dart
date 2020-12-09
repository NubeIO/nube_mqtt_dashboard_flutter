part of failures;

@freezed
abstract class CreatePinFailure extends Failure with _$CreatePinFailure {
  const factory CreatePinFailure.unexpected() = _UnexpectedEnterPin;
}
