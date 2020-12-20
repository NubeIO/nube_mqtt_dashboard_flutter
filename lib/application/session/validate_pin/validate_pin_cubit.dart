import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/core/internal_state.dart';
import '../../../domain/session/failures.dart';
import '../../../domain/session/session_repository_interface.dart';
import '../../validation/value_object.dart';

part 'validate_pin_cubit.freezed.dart';
part 'validate_pin_state.dart';

@injectable
class ValidatePinCubit extends Cubit<ValidatePinState> {
  final ISessionRepository _sessionRepository;
  ValidatePinCubit(this._sessionRepository) : super(ValidatePinState.initial());

  Future<void> validatePin(ValueObject<String> value) async {
    emit(state.copyWith(validateState: const InternalStateValue.loading()));

    final pin = value.getOrCrash();
    final result = await _sessionRepository.validatePin(pin);

    result.fold((failure) {
      emit(state.copyWith(validateState: InternalStateValue.failure(failure)));
    }, (value) {
      emit(state.copyWith(validateState: InternalStateValue.success(value)));
    });
  }
}
