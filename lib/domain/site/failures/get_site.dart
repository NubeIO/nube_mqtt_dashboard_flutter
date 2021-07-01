part of failures;

@freezed
abstract class GetSiteFailure extends Failure with _$GetSiteFailure {
  const factory GetSiteFailure.notFound() = _GetSiteNotFound;
  const factory GetSiteFailure.unexpected() = _UnexpectedGetSite;
}
