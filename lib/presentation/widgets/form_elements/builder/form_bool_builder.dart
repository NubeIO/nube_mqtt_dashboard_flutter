import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../application/validation/value_object.dart';
import '../../../../application/validation/value_validation_state.dart';
import '../../../../domain/core/failure.dart';

part 'form_bool_builder.freezed.dart';

typedef ValueListener = void Function(
  ValueObject<bool> value,
  bool valid,
);

typedef FormValidatorBuilder = Widget Function(
  BuildContext context,
  ValueObject<bool> value,
  ValueValidationState validationState,
  ValueChanged<bool> onValueChanged,
);

void emptyValidator(
  ValueObject<bool> value,
  // ignore: avoid_positional_boolean_parameters
  bool valid,
) {}

class FormBooleanBuilder extends StatefulWidget {
  final FormValidatorBuilder builder;
  final ValueListener _validityListener;
  final IBoolValidation _validation;
  final ValueObject<bool> initialValue;

  const FormBooleanBuilder({
    Key key,
    @required this.builder,
    IBoolValidation validation = const AnyBooleanValidation(),
    ValueListener validityListener = emptyValidator,
    this.initialValue,
  })  : _validation = validation,
        _validityListener = validityListener,
        super(key: key);

  @override
  _FormBooleanBuilderState createState() => _FormBooleanBuilderState();
}

class _FormBooleanBuilderState extends State<FormBooleanBuilder>
    with AutomaticKeepAliveClientMixin<FormBooleanBuilder> {
  @override
  bool get wantKeepAlive => true;

  ValueValidationState state = const ValueValidationState.initial();
  ValueObject<bool> _value;

  @override
  void initState() {
    _value = widget.initialValue ?? ValueObject(dartz.some(false));
    super.initState();
  }

  Future<void> _onValueChange(BuildContext context, bool value) async {
    _value = ValueObject(dartz.some(value));
    final result = await widget._validation.validate(input: value);
    final validationState = result.fold(
        (failure) => ValueValidationState.error(
            failure: widget._validation.mapper(failure)),
        (r) => ValueValidationState.success(input: value));
    _onResultChanged(validationState);
    setState(() {
      state = validationState;
    });
  }

  void _onResultChanged(ValueValidationState state) {
    state.maybeWhen(
      success: (input) => widget._validityListener(
          ValueObject(dartz.some(input as bool)), true),
      orElse: () => widget._validityListener(ValueObject.none(), false),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.builder(
      context,
      _value,
      state,
      (value) => _onValueChange(context, value),
    );
  }
}

typedef ValidationMapper<T> = String Function(T value);

abstract class IBoolValidation {
  final ValidationMapper<BooleanInputFailure> mapper;

  const IBoolValidation(this.mapper);

  Future<dartz.Either<BooleanInputFailure, bool>> validate({bool input});
}

class EitherBooleanValidation extends IBoolValidation {
  final bool Function(bool value) onValue;

  EitherBooleanValidation(
      {this.onValue, ValidationMapper<BooleanInputFailure> mapper})
      : super(mapper);

  @override
  Future<dartz.Either<BooleanInputFailure, bool>> validate({bool input}) async {
    if (onValue(input)) {
      return dartz.right(input);
    } else {
      return dartz.left(const BooleanInputFailure.invalid());
    }
  }
}

String emptyValidation(BooleanInputFailure failure) => "";

class AnyBooleanValidation extends IBoolValidation {
  const AnyBooleanValidation() : super(emptyValidation);

  @override
  Future<dartz.Either<BooleanInputFailure, bool>> validate({bool input}) async {
    return dartz.right(input);
  }
}

@freezed
abstract class BooleanInputFailure extends Failure with _$BooleanInputFailure {
  const factory BooleanInputFailure.invalid() = _InvalidBool;
}
