part of entities;

@freezed
abstract class Configuration with _$Configuration {
  const factory Configuration({
    @required String host,
    @required int port,
    @required String clientId,
    @required String layoutTopic,
    @required String username,
    @required String password,
  }) = _Configuration;
}
