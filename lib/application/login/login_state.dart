part of 'login_cubit.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @required ValueObject<String> username,
    @required ValueObject<String> password,
    @required
        InternalStateValue<LoginUserFailure, ProfileStatusType> loginState,
  }) = _Initial;

  factory LoginState.initial() => LoginState(
        username: ValueObject.none(),
        password: ValueObject.none(),
        loginState: const InternalStateValue.initial(),
      );
}
