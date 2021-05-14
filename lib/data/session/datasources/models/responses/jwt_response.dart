part of responses;

@freezed
abstract class JWTResponse with _$JWTResponse {
  const factory JWTResponse({
    @JsonKey(name: "jwt") String jwt,
    @JsonKey(name: "refresh_token") String refreshToken,
    @JsonKey(name: "id_token") String idToken,
  }) = _JWTResponse;

  factory JWTResponse.fromJson(Map<String, dynamic> json) =>
      _$JWTResponseFromJson(json);
}
