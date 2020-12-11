part of 'layout_cubit.dart';

@freezed
abstract class LayoutState with _$LayoutState {
  const factory LayoutState({
    @required LayoutBuilder layoutBuilder,
    @required InternalState<LayoutFailure> layoutState,
  }) = _Initial;

  factory LayoutState.initial() => LayoutState(
        layoutBuilder: LayoutBuilder.empty(),
        layoutState: const InternalState.initial(),
      );
}
