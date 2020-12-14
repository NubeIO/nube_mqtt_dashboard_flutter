part of failures;

@freezed
abstract class WidgetSetFailure extends Failure with _$WidgetSetFailure {
  const factory WidgetSetFailure.unexpected() = _UnexpectedSet;
}
