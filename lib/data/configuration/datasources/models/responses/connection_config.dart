part of responses;

@freezed
abstract class ConnectionConfigResponse with _$ConnectionConfigResponse {
  const factory ConnectionConfigResponse({
    @JsonKey(name: "enabled") bool enabled,
    @JsonKey(name: "master") bool master,
    @JsonKey(name: "name") String name,
    @JsonKey(name: "host") String host,
    @JsonKey(name: "port") int port,
    @JsonKey(name: "authentication") bool authentication,
    @JsonKey(name: "username") String username,
    @JsonKey(name: "password") String password,
    @JsonKey(name: "keepalive") int keepalive,
    @JsonKey(name: "qos") int qos,
    @JsonKey(name: "retain") bool retain,
    @JsonKey(name: "attempt_reconnect_on_unavailable")
        bool attemptReconnectOnunavailable,
    @JsonKey(name: "attempt_reconnect_secs") int attemptReconnectSecs,
    @JsonKey(name: "timeout") int timeout,
  }) = _ConnectionConfigResponse;

  factory ConnectionConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigResponseFromJson(json);
}
