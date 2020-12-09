part of 'validate_pin_cubit.dart';

@freezed
abstract class ValidatePinState with _$ValidatePinState {
  const factory ValidatePinState({
    @required InternalState<ValidatePinFailure> validateState,
  }) = _Initial;

  factory ValidatePinState.initial() => ValidatePinState(
        validateState: const InternalState.initial(),
      );
}
