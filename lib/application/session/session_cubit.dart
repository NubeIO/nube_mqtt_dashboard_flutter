import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/session/session_repository_interface.dart';

part 'session_cubit.freezed.dart';
part 'session_state.dart';

@injectable
class SessionCubit extends Cubit<SessionState> {
  final ISessionRepository _sessionRepository;
  SessionCubit(this._sessionRepository) : super(const SessionState.initial()) {
    getSession();
  }

  Future<void> getSession() async {
    final statusType = await _sessionRepository.getLoginStatus();
    switch (statusType) {
      case ProfileStatusType.LOGGED_OUT:
        emit(const SessionState.loggedOut());
        break;
      case ProfileStatusType.NEEDS_VERIFICATION:
        emit(const SessionState.needsVerification());
        break;
      case ProfileStatusType.PROFILE_EXISTS:
        final needsPin = await _sessionRepository.isPinProtected();
        if (needsPin) {
          emit(const SessionState.validatePin());
        } else {
          emit(const SessionState.authenticated());
        }
        break;
    }
  }
}
