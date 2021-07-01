part of entities;

@freezed
abstract class SiteAlert with _$SiteAlert {
  const factory SiteAlert({
    @required String siteId,
    @required String topic,
  }) = _SiteAlert;
}
