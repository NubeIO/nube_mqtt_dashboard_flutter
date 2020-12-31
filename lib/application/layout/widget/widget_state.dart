part of 'widget_cubit.dart';

@freezed
abstract class WidgetState with _$WidgetState {
  const factory WidgetState({
    @required MqttSubscriptionState subscriptionState,
    @required WidgetData data,
    @required InternalState<WidgetDataSubscribeFailure> loadState,
    @required InternalState<WidgetSetFailure> widgetSetState,
  }) = _Initial;

  // ignore: prefer_const_constructors
  factory WidgetState.initial() => WidgetState(
        subscriptionState: MqttSubscriptionState.IDLE,
        data: const WidgetData(value: 0),
        loadState: const InternalState.initial(),
        widgetSetState: const InternalState.initial(),
      );
}
