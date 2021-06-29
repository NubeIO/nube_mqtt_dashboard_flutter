part of entities;

@freezed
abstract class Site with _$Site {
  const factory Site({
    @required String uuid,
    @required String name,
    @nullable String address,
    @nullable String city,
    @nullable String state,
    @nullable int zip,
    @nullable String country,
    @nullable double latitude,
    @nullable double longitude,
    @nullable String timeZone,
  }) = _Site;
}
