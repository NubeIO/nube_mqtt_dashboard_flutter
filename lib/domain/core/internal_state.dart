import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure.dart';

part 'internal_state.freezed.dart';

@freezed
abstract class InternalState<F extends Failure> with _$InternalState<F> {
  const factory InternalState.initial() = _Initial;
  const factory InternalState.loading() = _Loading;
  const factory InternalState.success() = _Success;
  const factory InternalState.failure(F failure) = _Failure;
}

@freezed
abstract class InternalStateValue<F extends Failure, T>
    with _$InternalStateValue<F, T> {
  const factory InternalStateValue.initial() = _InitialWithValue;
  const factory InternalStateValue.loading() = _LoadingWithValue;
  const factory InternalStateValue.success(T value) = _SuccessWithValue;
  const factory InternalStateValue.failure(F failure) = _FailureWithValue;
}
