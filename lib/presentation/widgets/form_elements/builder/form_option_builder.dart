import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';

import '../../../../application/validation/value_validation_state.dart';
import '../../../models/form_options.dart';

typedef ValueListener<T> = void Function(dartz.Option<T> value, bool valid);

typedef FormValidatorBuilder = Widget Function(
  BuildContext context,
  ValueValidationState validationState,
  ValueChanged<FormOption> onValueChanged,
  FormOption selectedValue,
);

class FormOptionBuilder<T extends FormOption> extends StatefulWidget {
  final FormValidatorBuilder builder;
  final ValueListener<T> _validityListener;
  final T initialValue;
  const FormOptionBuilder({
    Key key,
    @required this.builder,
    ValueListener<T> validityListener,
    this.initialValue,
  })  : _validityListener = validityListener,
        super(key: key);

  @override
  _FormTextBuilderState<T> createState() => _FormTextBuilderState<T>();
}

class _FormTextBuilderState<T extends FormOption>
    extends State<FormOptionBuilder<T>>
    with AutomaticKeepAliveClientMixin<FormOptionBuilder<T>> {
  ValueValidationState _validationState = const ValueValidationState.initial();

  dartz.Option<T> _selectedValue = dartz.none();

  @override
  void initState() {
    super.initState();
    bool validity = false;
    if (widget.initialValue != null) {
      _selectedValue = dartz.some(widget.initialValue);
      validity = true;
    }
    widget._validityListener(_selectedValue, validity);
  }

  @override
  bool get wantKeepAlive => true;

  void _onValueChanged(input) {
    final state = dartz.some(input as T);
    setState(() {
      _selectedValue = state;
      _validationState = ValueValidationState.success(input: input as T);
    });
    widget._validityListener(state, true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(
      context,
      _validationState,
      _onValueChanged,
      _selectedValue.fold(() => null, (a) => a),
    );
  }
}
