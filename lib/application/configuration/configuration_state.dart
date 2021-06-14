part of 'configuration_cubit.dart';

@freezed
abstract class ConfigurationState with _$ConfigurationState {
  const factory ConfigurationState({
    @required bool dataReady,
    @required bool shouldReconnect,
    @required SupportedTheme currentTheme,
    @required ValueObject<String> accessPin,
    @required InternalState<CreatePinFailure> saveState,
    @required InternalState<LogoutFailure> logoutState,
  }) = _Initial;

  factory ConfigurationState.initial() => ConfigurationState(
        dataReady: false,
        shouldReconnect: false,
        currentTheme: const SupportedTheme.defaultTheme(),
        accessPin: ValueObject.none(),
        saveState: const InternalState.initial(),
        logoutState: const InternalState.initial(),
      );
}
