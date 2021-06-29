part of responses;

@freezed
abstract class UserResponse with _$UserResponse {
  const factory UserResponse({
    @JsonKey(name: "uuid") String uuid,
    @JsonKey(name: "first_name") String firstName,
    @JsonKey(name: "last_name") String lastName,
    @JsonKey(name: "email") String email,
    @JsonKey(name: "username") String username,
    @JsonKey(name: "state") String state,
    @JsonKey(name: "devices") List<DeviceResponse> devices,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@freezed
abstract class DeviceResponse with _$DeviceResponse {
  const factory DeviceResponse({
    @JsonKey(name: "uuid") String uuid,
    @JsonKey(name: "device_id") String deviceId,
  }) = _DeviceResponse;

  factory DeviceResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceResponseFromJson(json);
}
