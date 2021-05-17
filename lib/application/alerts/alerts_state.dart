part of 'alerts_cubit.dart';

@freezed
abstract class AlertsState with _$AlertsState {
  const factory AlertsState.initial() = _Initial;
}
