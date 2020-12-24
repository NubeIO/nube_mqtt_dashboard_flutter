import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../application/validation/value_object.dart';
import '../../../../application/validation/value_validation_state.dart';
import '../../../../domain/core/failure.dart';

part 'form_color_builder.freezed.dart';

typedef ValueListener = void Function(
  ValueObject<int> value,
  bool valid,
);

typedef FormValidatorBuilder = Widget Function(
  BuildContext context,
  ValueObject<Color> value,
  ValueValidationState validationState,
  ValueChanged<Color> onValueChanged,
);

void emptyValidator(
  ValueObject<int> value,
  bool valid,
) {}

class FormColorBuilder extends StatefulWidget {
  final FormValidatorBuilder builder;
  final ValueListener _validityListener;
  final IColorValidation _validation;
  final ValueObject<int> initialValue;

  const FormColorBuilder({
    Key key,
    @required this.builder,
    IColorValidation validation = const AnyColorValidation(),
    ValueListener validityListener = emptyValidator,
    this.initialValue,
  })  : _validation = validation,
        _validityListener = validityListener,
        super(key: key);

  @override
  _FormColorBuilderState createState() => _FormColorBuilderState();
}

class _FormColorBuilderState extends State<FormColorBuilder>
    with AutomaticKeepAliveClientMixin<FormColorBuilder> {
  @override
  bool get wantKeepAlive => true;

  ValueValidationState state = const ValueValidationState.initial();
  ValueObject<Color> _value;

  @override
  void initState() {
    _value = widget.initialValue == null && widget.initialValue.isValid
        ? ValueObject(dartz.some(Color(widget.initialValue.getOrCrash())))
        : ValueObject(dartz.some(Colors.transparent));
    super.initState();
  }

  Future<void> _onValueChange(BuildContext context, Color value) async {
    _value = ValueObject(dartz.some(value));
    final result = await widget._validation.validate(value);
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
          ValueObject(dartz.some((input as Color).value)), true),
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

abstract class IColorValidation {
  final ValidationMapper<ColorInputFailure> mapper;

  const IColorValidation(this.mapper);

  Future<dartz.Either<ColorInputFailure, Color>> validate(Color input);
}

String emptyValidation(ColorInputFailure failure) => "";

class AnyColorValidation extends IColorValidation {
  const AnyColorValidation() : super(emptyValidation);

  @override
  Future<dartz.Either<ColorInputFailure, Color>> validate(Color input) async {
    return dartz.right(input);
  }
}

@freezed
abstract class ColorInputFailure extends Failure with _$ColorInputFailure {
  const factory ColorInputFailure.invalid() = _InvalidColor;
}
