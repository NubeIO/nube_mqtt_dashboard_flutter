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
    final sessionType = await _sessionRepository.getSessionType();
    switch (sessionType) {
      case SessionType.REQUIRES_PIN:
        emit(const SessionState.validatePin());
        break;
      case SessionType.CREATE_PIN:
        emit(const SessionState.createPin());
        break;
    }
  }
}