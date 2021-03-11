part of 'log_cubit.dart';

@freezed
abstract class LogState with _$LogState {
  const factory LogState({
    @required KtList<LogItem> logs,
    @required InternalState<LogStreamFailure> streamState,
  }) = _Initial;

  factory LogState.initial() => LogState(
        logs: emptyList(),
        streamState: const InternalState.initial(),
      );
}
