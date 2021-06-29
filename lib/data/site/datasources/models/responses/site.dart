part of responses;

@freezed
abstract class SiteResponse with _$SiteResponse {
  const factory SiteResponse({
    @JsonKey(name: "uuid") String uuid,
    @nullable @JsonKey(name: "name") String name,
    @nullable @JsonKey(name: "address") String address,
    @nullable @JsonKey(name: "city") String city,
    @nullable @JsonKey(name: "state") String state,
    @nullable @JsonKey(name: "zip") int zip,
    @nullable @JsonKey(name: "country") String country,
    @nullable @JsonKey(name: "lat") double latitude,
    @nullable @JsonKey(name: "lon") double longitude,
    @nullable @JsonKey(name: "time_zone") String timeZone,
  }) = _SiteResponse;

  factory SiteResponse.fromJson(Map<String, dynamic> json) =>
      _$SiteResponseFromJson(json);
}
