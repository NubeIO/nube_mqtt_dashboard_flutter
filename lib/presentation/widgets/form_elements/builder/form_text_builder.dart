import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/validation/value_object.dart';
import '../../../../application/validation/value_validation_bloc.dart';
import '../../../../application/validation/value_validation_state.dart';
import '../../../../domain/core/validation_interface.dart';

typedef ValueListener<T> = void Function(
  T value,
  bool valid,
);

typedef FormValidatorBuilder<T> = Widget Function(
  BuildContext context,
  ValueValidationState validationState,
  ValueChanged<T> onValueChanged,
);

void emptyValidator(
  ValueObject<Object> value,
  // ignore: avoid_positional_boolean_parameters
  bool valid,
) {}

class FormTextBuilder<T> extends StatefulWidget {
  final FormValidatorBuilder<T> builder;
  final IValidation<dynamic, T> _validation;
  final ValueListener<ValueObject<T>> _validityListener;
  final ValueObject<T> initialValue;

  const FormTextBuilder({
    Key key,
    @required this.builder,
    @required IValidation<dynamic, T> validation,
    ValueListener<ValueObject<T>> validityListener = emptyValidator,
    this.initialValue,
  })  : _validation = validation,
        _validityListener = validityListener,
        super(key: key);

  @override
  _FormTextBuilderState<T> createState() => _FormTextBuilderState<T>();
}

class _FormTextBuilderState<T> extends State<FormTextBuilder<T>>
    with AutomaticKeepAliveClientMixin<FormTextBuilder<T>> {
  @override
  bool get wantKeepAlive => true;

  void _onValueChange(BuildContext context, T value) {
    context
        .read<ValueValidationBloc<T>>()
        .add(ValueValidationEvent.validate(value));
  }

  void _onResultChanged(ValueValidationState state) {
    state.maybeWhen(
      success: (input) =>
          widget._validityListener(ValueObject(dartz.some(input as T)), true),
      orElse: () => widget._validityListener(ValueObject.none(), false),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => ValueValidationBloc<T>(
        widget._validation,
        initial: widget.initialValue ?? ValueObject.none(),
      ),
      child: BlocConsumer<ValueValidationBloc<T>, ValueValidationState>(
        listener: (context, state) {
          _onResultChanged(state);
        },
        builder: (context, state) {
          return widget.builder(
            context,
            state,
            (value) => _onValueChange(context, value),
          );
        },
      ),
    );
  }
}
