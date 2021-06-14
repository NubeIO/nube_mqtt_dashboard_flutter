import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/session/session_repository_interface.dart';
import '../../domain/theme/theme_repository_interface.dart';
import '../../utils/logger/log.dart';
import '../validation/value_object.dart';

part 'configuration_cubit.freezed.dart';
part 'configuration_state.dart';

const String _TAG = "ConfigurationCubit";

@injectable
class ConfigurationCubit extends Cubit<ConfigurationState> {
  final ISessionRepository _sessionRepository;
  final IThemeRepository _themeRepository;

  StreamSubscription subscription;

  ConfigurationCubit(
    this._sessionRepository,
    this._themeRepository,
  ) : super(ConfigurationState.initial()) {
    _prefillData();
  }

  Future<void> setPin(ValueObject<String> value) async {
    emit(state.copyWith(accessPin: value));
    await next();
  }

  Future<void> next() async {
    emit(state.copyWith(saveState: const InternalState.loading()));

    final accessPin = state.accessPin.getOrElse("");

    final result = await _sessionRepository.createPin(accessPin);

    result.fold(
      (failure) => emit(
        state.copyWith(saveState: InternalState.failure(failure)),
      ),
      (_) => emit(
        state.copyWith(saveState: const InternalState.success()),
      ),
    );
  }

  Future<bool> isPinProtected() => _sessionRepository.isPinProtected();

  Future<void> _prefillData() async {
    final resultPins = await _sessionRepository.getPinConfiguration();

    if (resultPins.isSome()) {
      final pins = resultPins.fold(() => throw Error(), id);
      emit(
        state.copyWith(
          dataReady: true,
          accessPin: ValueObject(some(pins)),
        ),
      );
    } else {
      emit(
        state.copyWith(dataReady: true),
      );
    }

    subscription = _themeRepository.getThemeStream().listen((event) {
      event.fold((_) {}, (theme) => emit(state.copyWith(currentTheme: theme)));
    });
  }

  Future<void> logout() async {
    Log.d("Logging out user", tag: _TAG);
    emit(state.copyWith(logoutState: const InternalState.loading()));

    final result = await _sessionRepository.logout();

    result.fold(
      (failure) => emit(
        state.copyWith(logoutState: InternalState.failure(failure)),
      ),
      (_) => emit(
        state.copyWith(logoutState: const InternalState.success()),
      ),
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
