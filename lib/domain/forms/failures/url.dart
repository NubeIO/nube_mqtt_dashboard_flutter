part of failures;

@freezed
abstract class UrlFailure extends Failure with _$UrlFailure {
  const factory UrlFailure.invalidUrl() = _InvalidUrl;
  const factory UrlFailure.unexpected() = _UnexpectedUrl;
}
