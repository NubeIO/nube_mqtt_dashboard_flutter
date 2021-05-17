import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:nube_mqtt_dashboard/domain/session/session_data_source_interface.dart';
import 'package:nube_mqtt_dashboard/domain/session/session_repository_interface.dart';

part 'verification_state.dart';
part 'verification_cubit.freezed.dart';

@injectable
class VerificationCubit extends Cubit<VerificationState> {
  final ISessionRepository _sessionRepository;

  StreamSubscription<ProfileStatusType> subscription;

  VerificationCubit(this._sessionRepository)
      : super(VerificationState.initial()) {
    _subscribeToVerification();
  }

  void _subscribeToVerification() {
    subscription = _sessionRepository.loginStatusStream.listen((event) {
      _onStatusChange(event);
    });
  }

  void _onStatusChange(ProfileStatusType status) {
    emit(state.copyWith(status: status));
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
