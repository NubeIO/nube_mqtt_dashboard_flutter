part of 'create_pin_cubit.dart';

@freezed
abstract class CreatePinState with _$CreatePinState {
  const factory CreatePinState({
    @required InternalState<CreatePinFailure> state,
  }) = _Initial;

  factory CreatePinState.initial() => CreatePinState(
        state: const InternalState.initial(),
      );
}
