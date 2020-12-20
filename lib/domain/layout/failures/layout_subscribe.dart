part of failures;

@freezed
abstract class LayoutSubscribeFailure extends Failure
    with _$LayoutSubscribeFailure {
  const factory LayoutSubscribeFailure.noLayoutConfig() = _NoLayoutConfig;
  const factory LayoutSubscribeFailure.invalidConection() = _InvalidConnection;
  const factory LayoutSubscribeFailure.unexpected() = _UnexpectedLayoutSub;
}
