part of 'alerts_cubit.dart';

@freezed
abstract class AlertsState with _$AlertsState {
  const factory AlertsState({
    @required AlertEntity alert,
    @required bool alertsEnabled,
    @required InternalState<AlertFailure> alertState,
  }) = _Initial;

  factory AlertsState.initial() => AlertsState(
        alert: AlertEntity.empty(),
        alertsEnabled: false,
        alertState: const InternalState.initial(),
      );
}
