part of requests;

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    @required @JsonKey(name: "username") String username,
    @required @JsonKey(name: "password") String password,
    @required @JsonKey(name: "device_id") String deviceId,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
