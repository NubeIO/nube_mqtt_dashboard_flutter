part of failures;

@freezed
abstract class SaveFailure extends Failure with _$SaveFailure {
  const factory SaveFailure.unexpected() = _UnexpectedSaveFailure;
}
