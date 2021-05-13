part of 'validate_pin_cubit.dart';

@freezed
abstract class ValidatePinState with _$ValidatePinState {
  const factory ValidatePinState({
    @required InternalStateValue<ValidatePinFailure, Unit> validateState,
  }) = _Initial;

  // ignore: prefer_const_constructors
  factory ValidatePinState.initial() => ValidatePinState(
        validateState: const InternalStateValue.initial(),
      );
}
