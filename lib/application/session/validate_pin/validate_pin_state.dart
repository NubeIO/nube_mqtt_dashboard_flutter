part of 'validate_pin_cubit.dart';

@freezed
abstract class ValidatePinState with _$ValidatePinState {
  const factory ValidatePinState({
    @required InternalStateValue<ValidatePinFailure, UserType> validateState,
  }) = _Initial;

  // ignore: prefer_const_constructors
  factory ValidatePinState.initial() => ValidatePinState(
        validateState: const InternalStateValue.initial(),
      );
}
