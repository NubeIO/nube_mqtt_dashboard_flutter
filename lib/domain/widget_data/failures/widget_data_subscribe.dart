part of failures;

@freezed
abstract class WidgetDataSubscribeFailure extends Failure
    with _$WidgetDataSubscribeFailure {
  const factory WidgetDataSubscribeFailure.unexpected() = _UnexpectedLoad;
}
