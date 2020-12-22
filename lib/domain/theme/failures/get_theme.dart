part of failures;

@freezed
abstract class GetThemeFailure extends Failure with _$GetThemeFailure {
  const factory GetThemeFailure.unexpected() = _UnexpectedGet;
}
