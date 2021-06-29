part of failures;

@freezed
abstract class SetSiteFailure extends Failure with _$SetSiteFailure {
  const factory SetSiteFailure.unexpected() = _UnexpectedSetSite;
}
