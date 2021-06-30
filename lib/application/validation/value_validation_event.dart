part of 'value_validation_bloc.dart';

@freezed
abstract class ValueValidationEvent with _$ValueValidationEvent {
  const factory ValueValidationEvent.validate(dynamic input) = _Validate;
}
