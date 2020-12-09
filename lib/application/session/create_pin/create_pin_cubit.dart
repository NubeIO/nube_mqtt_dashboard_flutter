import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/core/internal_state.dart';
import '../../../domain/session/failures.dart';
import '../../../domain/session/session_repository_interface.dart';
import '../../validation/value_object.dart';

part 'create_pin_cubit.freezed.dart';
part 'create_pin_state.dart';

@injectable
class CreatePinCubit extends Cubit<CreatePinState> {
  final ISessionRepository _sessionRepository;
  CreatePinCubit(this._sessionRepository) : super(CreatePinState.initial());

  Future<void> createPin(ValueObject<String> value) async {
    emit(state.copyWith(state: const InternalState.loading()));

    final pin = value.getOrCrash();
    final result = await _sessionRepository.createPin(pin);
    result.fold((failure) {
      emit(state.copyWith(state: InternalState.failure(failure)));
    }, (_) {
      emit(state.copyWith(state: const InternalState.success()));
    });
  }
}
