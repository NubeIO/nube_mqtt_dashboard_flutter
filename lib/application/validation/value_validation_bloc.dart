import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/core/validation_interface.dart';
import 'value_object.dart';
import 'value_validation_state.dart';

part 'value_validation_bloc.freezed.dart';
part 'value_validation_event.dart';

class ValueValidationBloc<T>
    extends Bloc<ValueValidationEvent, ValueValidationState> {
  final IValidation<dynamic, T> _validation;

  ValueValidationBloc(
    IValidation<dynamic, T> validation, {
    ValueObject<String> initial,
  })  : _validation = validation,
        super(const ValueValidationState.initial()) {
    if (initial.isValid) {
      add(ValueValidationEvent.validate(initial.getOrCrash()));
    }
  }

  bool get isValid => state.maybeWhen(
        success: (_) => true,
        orElse: () => false,
      );

  ValueObject<T> get value => state.maybeWhen(
        success: (value) => ValueObject(some(value as T)),
        orElse: () => ValueObject.none(),
      );

  @override
  Stream<Transition<ValueValidationEvent, ValueValidationState>>
      transformEvents(
    Stream<ValueValidationEvent> events,
    TransitionFunction<ValueValidationEvent, ValueValidationState> transitionFn,
  ) {
    return super.transformEvents(
      events.distinct().debounceTime(const Duration(milliseconds: 100)),
      transitionFn,
    );
  }

  @override
  Stream<Transition<ValueValidationEvent, ValueValidationState>>
      transformTransitions(
    Stream<Transition<ValueValidationEvent, ValueValidationState>> transitions,
  ) {
    return transitions
        .distinct()
        .debounceTime(const Duration(milliseconds: 100));
  }

  @override
  Stream<ValueValidationState> mapEventToState(
    ValueValidationEvent event,
  ) async* {
    yield const ValueValidationState.loading();

    yield* event.when(validate: (value) async* {
      final result = await _validation.validate(value);
      yield result.fold(
        (error) =>
            ValueValidationState.error(failure: _validation.mapFailure(error)),
        (output) => ValueValidationState.success(input: output),
      );
    });
  }
}
