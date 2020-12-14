part of 'widget_cubit.dart';

@freezed
abstract class WidgetState with _$WidgetState {
  const factory WidgetState({
    @required MqttSubscriptionState subscriptionState,
    @required
        InternalStateValue<WidgetDataSubscribeFailure, WidgetData> loadState,
    @required InternalState<WidgetSetFailure> widgetSetState,
  }) = _Initial;

  // ignore: prefer_const_constructors
  factory WidgetState.initial() => WidgetState(
        subscriptionState: MqttSubscriptionState.IDLE,
        loadState: const InternalStateValue.initial(),
        widgetSetState: const InternalState.initial(),
      );
}
