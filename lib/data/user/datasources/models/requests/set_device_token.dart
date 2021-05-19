part of requests;

@freezed
abstract class SetDeviceTokenRequest with _$SetDeviceTokenRequest {
  const factory SetDeviceTokenRequest({
    @required @JsonKey(name: "device_id") String deviceId,
  }) = _SetDeviceTokenRequest;

  factory SetDeviceTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$SetDeviceTokenRequestFromJson(json);
}
