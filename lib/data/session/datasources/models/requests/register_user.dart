part of requests;

@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    @required @JsonKey(name: "first_name") String firstName,
    @required @JsonKey(name: "last_name") String lastName,
    @required @JsonKey(name: "username") String username,
    @required @JsonKey(name: "email") String email,
    @required @JsonKey(name: "password") String password,
    @required @JsonKey(name: "device_id") String deviceId,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}
