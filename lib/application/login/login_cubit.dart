import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/session/failures.dart';
import '../../domain/session/session_repository_interface.dart';
import '../validation/value_object.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

const String TAG = "LoginCubit";

@injectable
class LoginCubit extends Cubit<LoginState> {
  final ISessionRepository _sessionRepository;

  LoginCubit(this._sessionRepository) : super(LoginState.initial());

  bool get isValid => state.username.isValid && state.password.isValid;

  void setUsername(ValueObject<String> username) => emit(
        state.copyWith(
          username: username,
        ),
      );

  void setPassword(ValueObject<String> password) => emit(
        state.copyWith(
          password: password,
        ),
      );

  Future<void> login() async {
    emit(state.copyWith(loginState: const InternalStateValue.loading()));

    final username = state.username.getOrCrash();
    final password = state.password.getOrCrash();

    final result = await _sessionRepository.loginUser(username, password);

    result.fold(
      (failue) => emit(
        state.copyWith(
          loginState: InternalStateValue.failure(failue),
        ),
      ),
      (profileStatusType) => emit(
        state.copyWith(
            loginState: InternalStateValue.success(profileStatusType)),
      ),
    );
  }
}
