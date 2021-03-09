part of 'layout_cubit.dart';

@freezed
abstract class LayoutState with _$LayoutState {
  const factory LayoutState({
    @required LayoutEntity layout,
    @required KtList<PageEntity> pages,
    PageEntity selectedPage,
    @required InternalState<LayoutSubscribeFailure> layoutConnection,
    @required InternalState<LayoutFailure> layoutState,
    @required TimerStatus<PageEntity> pageTimeout,
  }) = _Initial;

  factory LayoutState.initial() => LayoutState(
        layout: LayoutEntity.empty(),
        pages: emptyList(),
        layoutConnection: const InternalState.initial(),
        layoutState: const InternalState.initial(),
        pageTimeout: const TimerStatus.initial(),
      );
}
