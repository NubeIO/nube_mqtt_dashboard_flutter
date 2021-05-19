part of responses;

@freezed
abstract class JWTResponse with _$JWTResponse {
  const factory JWTResponse({
    @JsonKey(name: "access_token") String accessToken,
    @JsonKey(name: "token_type") String tokenType,
  }) = _JWTResponse;

  factory JWTResponse.fromJson(Map<String, dynamic> json) =>
      _$JWTResponseFromJson(json);
}
