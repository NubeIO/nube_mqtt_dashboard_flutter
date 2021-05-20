part of requests;

@freezed
abstract class CheckUsernameRequest with _$CheckUsernameRequest {
  const factory CheckUsernameRequest({
    @required @JsonKey(name: "username") String username,
  }) = _CheckUsernameRequest;

  factory CheckUsernameRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckUsernameRequestFromJson(json);
}
