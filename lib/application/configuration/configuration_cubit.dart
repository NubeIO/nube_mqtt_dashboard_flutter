import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/configuration/configuration_repository_interface.dart';
import '../../domain/core/internal_state.dart';
import '../validation/value_object.dart';

part 'configuration_cubit.freezed.dart';
part 'configuration_state.dart';

@injectable
class ConfigurationCubit extends Cubit<ConfigurationState> {
  final IConfigurationRepository _configurationRepository;

  ConfigurationCubit(
    this._configurationRepository,
  ) : super(ConfigurationState.initial()) {
    _prefillData();
  }

  bool get isValid =>
      state.host.isValid && state.port.isValid && state.clientId.isValid;

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

  Future<void> connect() async {
    emit(state.copyWith(connectState: const InternalState.loading()));

    final host = state.host.getOrCrash();
    final port = state.port.getOrCrash();
    final clientId = state.clientId.getOrCrash();
    final username = state.username.getOrElse("");
    final password = state.password.getOrElse("");

    final result = await _configurationRepository.connect(
      host: host,
      port: port,
      clientId: clientId,
      username: username,
      password: password,
    );

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
    final result = await _configurationRepository.getConfiguration();
    result.fold(() {
      emit(
        state.copyWith(dataReady: true),
      );
    }, (config) {
      emit(
        state.copyWith(
          dataReady: true,
          connectState: const InternalState.initial(),
          host: ValueObject(some(config.host)),
          port: ValueObject(some(config.port)),
          clientId: ValueObject(some(config.clientId)),
          username: ValueObject(some(config.username)),
          password: ValueObject(some(config.password)),
        ),
      );
    });
  }
}
