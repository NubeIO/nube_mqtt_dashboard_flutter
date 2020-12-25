part of 'configuration_cubit.dart';

@freezed
abstract class ConfigurationState with _$ConfigurationState {
  const factory ConfigurationState({
    @required bool dataReady,
    @required bool shouldReconnect,
    @required SupportedTheme currentTheme,
    @required ValueObject<String> host,
    @required ValueObject<int> port,
    @required ValueObject<String> clientId,
    @required ValueObject<String> layoutTopic,
    @required ValueObject<String> username,
    @required ValueObject<String> password,
    @required ValueObject<String> adminPin,
    @required ValueObject<String> userPin,
    @required InternalState<SaveFailure> saveConfigState,
    @required InternalState<CreatePinFailure> savePinState,
    @required InternalState<ConnectFailure> connectState,
  }) = _Initial;

  factory ConfigurationState.initial() => ConfigurationState(
        dataReady: false,
        shouldReconnect: false,
        currentTheme: const SupportedTheme.defaultTheme(),
        host: ValueObject.none(),
        port: ValueObject.none(),
        clientId: ValueObject.none(),
        username: ValueObject.none(),
        password: ValueObject.none(),
        layoutTopic: ValueObject.none(),
        adminPin: ValueObject.none(),
        userPin: ValueObject.none(),
        saveConfigState: const InternalState.initial(),
        savePinState: const InternalState.initial(),
        connectState: const InternalState.initial(),
      );
}
