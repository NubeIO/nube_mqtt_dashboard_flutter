import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/notifications/entities.dart';
import '../../domain/notifications/failures.dart';
import '../../domain/notifications/notification_repository_interface.dart';

part 'alerts_cubit.freezed.dart';
part 'alerts_state.dart';

@injectable
class AlertsCubit extends Cubit<AlertsState> {
  final INotificationRepository _notificationRepository;

  AlertsCubit(this._notificationRepository) : super(AlertsState.initial()) {
    _listen();
  }

  StreamSubscription<Either<AlertFailure, AlertEntity>> subscription;

  void _listen() {
    subscription = _notificationRepository.alertStream.listen((event) {
      _onAlertsChange(event);
    });
  }

  void _onAlertsChange(Either<AlertFailure, AlertEntity> event) {
    event.fold(
      (failure) => emit(
        state.copyWith(
          alertState: InternalState.failure(failure),
        ),
      ),
      (alerts) {
        emit(state.copyWith(
          alert: alerts,
          alertState: const InternalState.success(),
        ));
      },
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
