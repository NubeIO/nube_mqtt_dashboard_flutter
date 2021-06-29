part of failures;

@freezed
abstract class SiteFailure extends Failure with _$SiteFailure {
  const factory SiteFailure.unexpected() = _UnexpectedSite;
}
