part of failures;

@freezed
abstract class FetchSiteFailure extends Failure with _$FetchSiteFailure {
  const factory FetchSiteFailure.unexpected() = _UnexpectedFetchSite;
  const factory FetchSiteFailure.connection() = _ConnectionFetchSite;
  const factory FetchSiteFailure.invalidToken() = _InvalidTokenFetchSite;
  const factory FetchSiteFailure.server() = _ServerFetchSite;
  const factory FetchSiteFailure.general(String message) = _GeneralFetchSite;
}
