part of 'alerts_cubit.dart';

@freezed
abstract class AlertsState with _$AlertsState {
  const factory AlertsState({
    @required AlertEntity alert,
    @required InternalState<AlertFailure> alertState,
  }) = _Initial;

  factory AlertsState.initial() => AlertsState(
        alert: AlertEntity.empty(),
        alertState: const InternalState.initial(),
      );
}
