import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/configuration/configuration_repository_interface.dart';
import '../../domain/core/internal_state.dart';
import '../../domain/mqtt/failures.dart';
import '../../domain/mqtt/mqtt_repository.dart';
import '../../domain/session/session_repository_interface.dart';
import '../../domain/theme/theme_repository_interface.dart';
import '../validation/value_object.dart';

part 'configuration_cubit.freezed.dart';
part 'configuration_state.dart';

@injectable
class ConfigurationCubit extends Cubit<ConfigurationState> {
  final IConfigurationRepository _configurationRepository;
  final ISessionRepository _sessionRepository;
  final IMqttRepository _mqttRepository;
  final IThemeRepository _themeRepository;

  StreamSubscription subscription;

  ConfigurationCubit(
    this._configurationRepository,
    this._sessionRepository,
    this._mqttRepository,
    this._themeRepository,
  ) : super(ConfigurationState.initial()) {
    _prefillData();
  }

  bool get isValid =>
      state.host.isValid &&
      state.port.isValid &&
      state.clientId.isValid &&
      state.layoutTopic.isValid &&
      state.adminPin.isValid;

  void setHost(ValueObject<String> value) => emit(
        state.copyWith(
          host: value,
          connectState: const InternalState.initial(),
        ),
      );

  void setPort(ValueObject<int> value) => emit(
        state.copyWith(
          port: value,
          connectState: const InternalState.initial(),
        ),
      );

  void setClientId(ValueObject<String> value) => emit(
        state.copyWith(
          clientId: value,
          connectState: const InternalState.initial(),
        ),
      );

  void setLayoutTopic(ValueObject<String> value) => emit(
        state.copyWith(
          layoutTopic: value,
          connectState: const InternalState.initial(),
        ),
      );

  void setUsername(ValueObject<String> value) => emit(
        state.copyWith(
          username: value,
          connectState: const InternalState.initial(),
        ),
      );

  void setPassword(ValueObject<String> value) => emit(
        state.copyWith(
          password: value,
          connectState: const InternalState.initial(),
        ),
      );

  void setAdminPin(ValueObject<String> value) => emit(
        state.copyWith(
          adminPin: value,
          connectState: const InternalState.initial(),
        ),
      );

  void setUserPin(ValueObject<String> value) => emit(
        state.copyWith(
          userPin: value,
          connectState: const InternalState.initial(),
        ),
      );

  Future<void> connect() async {
    await _saveConfig();
    await _savePins();
    await _connect();
  }

  Future<void> _saveConfig() async {
    emit(state.copyWith(saveConfigState: const InternalState.loading()));

    final host = state.host.getOrCrash();
    final port = state.port.getOrCrash();
    final clientId = state.clientId.getOrCrash();
    final layoutTopic = state.layoutTopic.getOrCrash();
    final username = state.username.getOrElse("");
    final password = state.password.getOrElse("");

    final result = await _configurationRepository.save(
      host: host,
      port: port,
      clientId: clientId,
      username: username,
      password: password,
      layoutTopic: layoutTopic,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(saveConfigState: InternalState.failure(failure)),
      ),
      (shouldReconnect) => emit(
        state.copyWith(
          saveConfigState: const InternalState.success(),
          shouldReconnect: shouldReconnect,
        ),
      ),
    );
  }

  Future<void> _savePins() async {
    // emit(state.copyWith(savePinState: const InternalState.loading()));

    // final adminPin = state.adminPin.getOrCrash();
    // final userPin = state.userPin.getOrElse("");

    // final result = await _sessionRepository.createPins(
    //     adminPin: adminPin, userPin: userPin);

    // result.fold(
    //   (failure) => emit(
    //     state.copyWith(savePinState: InternalState.failure(failure)),
    //   ),
    //   (_) => emit(
    //     state.copyWith(savePinState: const InternalState.success()),
    //   ),
    // );
  }

  Future<void> _connect() async {
    emit(state.copyWith(connectState: const InternalState.loading()));

    final host = state.host.getOrCrash();
    final port = state.port.getOrCrash();
    final clientId = state.clientId.getOrCrash();
    final username = state.username.getOrElse("");
    final password = state.password.getOrElse("");

    final result = await _mqttRepository.login(ConnectionConfig(
      host: host,
      port: port,
      clientId: clientId,
      username: username,
      password: password,
    ));

    result.fold(
      (failure) => emit(
        state.copyWith(connectState: InternalState.failure(failure)),
      ),
      (_) => emit(
        state.copyWith(connectState: const InternalState.success()),
      ),
    );
  }

  Future<void> _prefillData() async {
    // final resultConfigs = await _configurationRepository.getConfiguration();
    // final resultPins = await _sessionRepository.getPinConfiguration();

    // if (resultPins.isSome() && resultPins.isSome()) {
    //   final config = resultConfigs.getOrCrash();
    //   final pins = resultPins.getOrCrash();
    //   emit(
    //     state.copyWith(
    //       dataReady: true,
    //       connectState: const InternalState.initial(),
    //       host: ValueObject(some(config.host)),
    //       port: ValueObject(some(config.port)),
    //       clientId: ValueObject(some(config.clientId)),
    //       layoutTopic: ValueObject(some(config.layoutTopic)),
    //       username: ValueObject(some(config.username)),
    //       password: ValueObject(some(config.password)),
    //       adminPin: ValueObject(some(pins.adminPin)),
    //       userPin: ValueObject(some(pins.userPin)),
    //     ),
    //   );
    // } else {
    //   emit(
    //     state.copyWith(dataReady: true),
    //   );
    // }

    // subscription = _themeRepository.getThemeStream().listen((event) {
    //   event.fold((_) {}, (theme) => emit(state.copyWith(currentTheme: theme)));
    // });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
