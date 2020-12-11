part of 'configuration_cubit.dart';

@freezed
abstract class ConfigurationState with _$ConfigurationState {
  const factory ConfigurationState({
    @required bool dataReady,
    @required ValueObject<String> host,
    @required ValueObject<int> port,
    @required ValueObject<String> clientId,
    @required ValueObject<String> username,
    @required ValueObject<String> password,
    @required InternalState<SaveAndConnectFailure> connectState,
  }) = _Initial;

  factory ConfigurationState.initial() => ConfigurationState(
        dataReady: false,
        host: ValueObject.none(),
        port: ValueObject.none(),
        clientId: ValueObject.none(),
        username: ValueObject.none(),
        password: ValueObject.none(),
        connectState: const InternalState.initial(),
      );
}
