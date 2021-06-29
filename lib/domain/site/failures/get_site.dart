part of failures;

@freezed
abstract class GetSiteFailure extends Failure with _$GetSiteFailure {
  const factory GetSiteFailure.unexpected() = _UnexpectedGetSite;
  const factory GetSiteFailure.connection() = _ConnectionGetSite;
  const factory GetSiteFailure.invalidToken() = _InvalidTokenGetSite;
  const factory GetSiteFailure.server() = _ServerGetSite;
  const factory GetSiteFailure.general(String message) = _GeneralGetSite;
}
