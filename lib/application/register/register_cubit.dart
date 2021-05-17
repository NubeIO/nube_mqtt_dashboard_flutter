import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:nube_mqtt_dashboard/domain/session/session_repository_interface.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/session/failures.dart';
import '../validation/value_object.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final ISessionRepository _sessionRepository;

  RegisterCubit(this._sessionRepository) : super(RegisterState.initial());

  void setFirstName(ValueObject<String> value) {
    emit(state.copyWith(firstName: value));
  }

  void setLastName(ValueObject<String> value) {
    emit(state.copyWith(lastName: value));
  }

  void setUsername(ValueObject<String> value) {
    emit(state.copyWith(username: value));
  }

  void setEmail(ValueObject<String> value) {
    emit(state.copyWith(email: value));
  }

  void setPassword(ValueObject<String> value) {
    emit(state.copyWith(password: value));
  }

  void setConfirmPassword(ValueObject<String> value) {
    emit(state.copyWith(confirmPassword: value));
  }

  void onPageChanged(int value) {
    switch (value) {
      case 2:
        emit(state.copyWith(currentPage: const RegistrationCurrentPage.last()));
        break;
      case 1:
        emit(state.copyWith(
            currentPage: const RegistrationCurrentPage.second()));
        break;
      default:
        emit(
            state.copyWith(currentPage: const RegistrationCurrentPage.first()));
    }
  }

  bool get isValid => state.currentPage.when(
        first: () => isFirstPageValid,
        second: () => isSecondPageValid,
        last: () => isLastPageValid,
      );

  bool get isFirstPageValid =>
      state.firstName.isValid && state.lastName.isValid;

  bool get isSecondPageValid => state.username.isValid && state.email.isValid;

  bool get isLastPageValid =>
      state.password.isValid && state.confirmPassword.isValid;

  Future<void> register() async {
    emit(state.copyWith(registerState: const InternalState.loading()));

    final firstName = state.firstName.getOrCrash();
    final lastName = state.lastName.getOrCrash();
    final username = state.username.getOrCrash();
    final email = state.email.getOrCrash();
    final password = state.password.getOrCrash();

    final result = await _sessionRepository.createUser(CreateUserEntity(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      username: username,
    ));

    result.fold(
      (failue) => emit(
        state.copyWith(registerState: InternalState.failure(failue)),
      ),
      (_) => emit(
        state.copyWith(registerState: const InternalState.success()),
      ),
    );
  }
}
