part of requests;

@freezed
abstract class CheckEmailRequest with _$CheckEmailRequest {
  const factory CheckEmailRequest({
    @required @JsonKey(name: "email") String email,
  }) = _CheckEmailRequest;

  factory CheckEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckEmailRequestFromJson(json);
}
