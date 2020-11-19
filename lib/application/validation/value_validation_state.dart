import 'package:framy_annotation/framy_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_validation_state.freezed.dart';

@framyModel
@freezed
abstract class ValueValidationState with _$ValueValidationState {
  const factory ValueValidationState.initial() = Initial;
  const factory ValueValidationState.loading() = Loading;
  const factory ValueValidationState.success({dynamic input}) = Success;
  const factory ValueValidationState.error({String failure}) = FailureState;
}

extension ValueValidationStateX on ValueValidationState {
  bool get isValid => maybeWhen(orElse: () => false, success: (_) => true);

  String getErrorMessage() {
    final error = maybeWhen(orElse: () => "", error: (message) => message);
    if (error.isEmpty) {
      return null;
    } else {
      return error;
    }
  }
}
