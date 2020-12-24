part of 'layout_cubit.dart';

@freezed
abstract class LayoutState with _$LayoutState {
  const factory LayoutState({
    @required LayoutEntity layout,
    @required InternalState<LayoutSubscribeFailure> layoutConnection,
    @required InternalState<LayoutFailure> layoutState,
  }) = _Initial;

  factory LayoutState.initial() => LayoutState(
        layout: LayoutEntity.empty(),
        layoutConnection: const InternalState.initial(),
        layoutState: const InternalState.initial(),
      );
}
