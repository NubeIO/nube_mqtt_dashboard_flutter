part of responses;

@freezed
abstract class AvailableResponse with _$AvailableResponse {
  const factory AvailableResponse({
    @JsonKey(name: "exist") bool exist,
  }) = _AvailableResponse;

  factory AvailableResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableResponseFromJson(json);
}
