part of responses;

@freezed
abstract class DeviceTokenReponse with _$DeviceTokenReponse {
  const factory DeviceTokenReponse({
    @JsonKey(name: "uuid") String uuid,
    @JsonKey(name: "user_uuid") String userId,
    @JsonKey(name: "device_id") String deviceId,
  }) = _DeviceTokenReponse;

  factory DeviceTokenReponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenReponseFromJson(json);
}
