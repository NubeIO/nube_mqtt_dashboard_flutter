part of entities;

@freezed
abstract class ConnectionConfig with _$ConnectionConfig {
  const factory ConnectionConfig({
    @Default("") String host,
    @Default(1883) int port,
    @Default("") String clientId,
    @Default("") String username,
    @Default("") String password,
  }) = _ConnectionConfig;

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigFromJson(json);
}
