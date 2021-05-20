import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';
part 'config.g.dart';

@freezed
abstract class ConnectionConfig with _$ConnectionConfig {
  const factory ConnectionConfig({
    @Default("") String host,
    @Default(1883) int port,
    @Default("") String clientId,
    @Default(false) bool authentication,
    @Default("") String username,
    @Default("") String password,
  }) = _ConnectionConfig;

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigFromJson(json);
}
