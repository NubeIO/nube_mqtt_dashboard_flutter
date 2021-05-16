part of 'login_cubit.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @required ValueObject<String> username,
    @required ValueObject<String> password,
    @required InternalState<LoginUserFailure> loginState,
  }) = _Initial;

  factory LoginState.initial() => LoginState(
        username: ValueObject.none(),
        password: ValueObject.none(),
        loginState: const InternalState.initial(),
      );
}
