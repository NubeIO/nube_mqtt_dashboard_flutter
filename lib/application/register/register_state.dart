part of 'register_cubit.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @required ValueObject<String> firstName,
    @required ValueObject<String> lastName,
    @required ValueObject<String> username,
    @required ValueObject<String> email,
    @required ValueObject<String> password,
    @required ValueObject<String> confirmPassword,
    @required InternalState<CreateUserFailure> registerState,
    @required RegistrationCurrentPage currentPage,
  }) = _Initial;

  factory RegisterState.initial() => RegisterState(
        firstName: ValueObject.none(),
        lastName: ValueObject.none(),
        username: ValueObject.none(),
        email: ValueObject.none(),
        password: ValueObject.none(),
        confirmPassword: ValueObject.none(),
        registerState: const InternalState.initial(),
        currentPage: const RegistrationCurrentPage.first(),
      );
}

@freezed
abstract class RegistrationCurrentPage with _$RegistrationCurrentPage {
  const factory RegistrationCurrentPage.first() = _First;
  const factory RegistrationCurrentPage.second() = _Second;
  const factory RegistrationCurrentPage.last() = _Last;
}
