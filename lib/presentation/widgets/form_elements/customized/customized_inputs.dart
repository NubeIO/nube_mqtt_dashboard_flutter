import 'dart:core';

import 'package:flutter/material.dart';

import '../../../../application/validation/value_object.dart';
import '../../../../application/validation/value_validation_state.dart';
import '../../../../constants/app_constants.dart';
import '../../../../domain/core/validation_interface.dart';
import '../../../../domain/forms/length_validation.dart';
import '../../responsive/padding.dart';
import '../builder/form_text_builder.dart';
import '../checkbox_input.dart';
import '../text_input.dart';

class BuildForm extends StatelessWidget {
  final Widget child;

  const BuildForm({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: child,
      ),
    );
  }
}

class FormExpansionTile extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const FormExpansionTile({
    Key key,
    @required this.label,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.headline3,
      ),
      maintainState: true,
      initiallyExpanded: true,
      tilePadding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.padding(
          context,
          size: PaddingSize.medium,
        ),
      ),
      children: children,
    );
  }
}

class FormStringInput extends StatelessWidget {
  final IValidation<Object, String> validation;
  final String label;
  final ValueObject<String> initialValue;
  final void Function(ValueObject<String> value) onChanged;
  final VoidCallback onEditingComplete;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool isRequired;

  const FormStringInput({
    Key key,
    this.validation,
    this.label,
    this.initialValue,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.isRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormTextBuilder<String>(
      validation: validation,
      builder: (context, state, onValueChanged) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.padding(
              context,
              size: PaddingSize.medium,
            ),
          ),
          child: TextInput(
            initialValue: initialValue.getOrElse(""),
            validationState: state,
            onValueChanged: onValueChanged,
            textInputAction: textInputAction,
            label: label,
            keyboardType: keyboardType,
            onEditingComplete: onEditingComplete,
            helperText: isRequired
                ? state.isValid
                    ? null
                    : "Required"
                : null,
          ),
        );
      },
      initialValue: isRequired ? initialValue : null,
      validityListener: (value, valid) {
        onChanged(value);
      },
    );
  }
}

class FormPinInput extends StatelessWidget {
  final String label;
  final Future<String> Function() getPin;
  final ValueObject<String> initialValue;
  final void Function(ValueObject<String> value) onChanged;
  final bool isRequired;

  const FormPinInput({
    Key key,
    @required this.label,
    @required this.getPin,
    @required this.initialValue,
    @required this.onChanged,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormTextBuilder<String>(
      validation: LengthValidation(
        length: AppConstants.PIN_LENGTH,
        mapper: (failure) => failure.when(
          invalidLength: () => "Invalid Length",
        ),
      ),
      builder: (context, state, onValueChanged) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.padding(
              context,
              size: PaddingSize.medium,
            ),
          ),
          child: SwitchInput(
            label: label,
            onValueChanged: (value) async {
              if (value) {
                final pin = await getPin();
                onValueChanged(pin ?? "");
              } else {
                onValueChanged("");
              }
            },
            isError: state.maybeWhen(
              error: (_) => true,
              orElse: () => false,
            ),
            helperText: isRequired
                ? state.isValid
                    ? null
                    : "Required"
                : null,
            isCheck: state.isValid,
          ),
        );
      },
      initialValue: initialValue,
      validityListener: (value, valid) {
        onChanged(value);
      },
    );
  }
}

class FormIntInput extends StatelessWidget {
  final IValidation<Object, int> validation;
  final String label;
  final ValueObject<int> initialValue;
  final void Function(ValueObject<int> value) onChanged;
  final VoidCallback onEditingComplete;
  final TextInputAction textInputAction;
  final int fallbackValue;

  const FormIntInput({
    Key key,
    this.validation,
    this.label,
    this.initialValue,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.next,
    this.fallbackValue = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultValue = initialValue.getOrElse(fallbackValue);

    return FormTextBuilder<int>(
      validation: validation,
      builder: (context, state, onValueChanged) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.padding(
              context,
              size: PaddingSize.medium,
            ),
          ),
          child: TextInput(
            initialValue: defaultValue.toString(),
            validationState: state,
            onValueChanged: onValueChanged,
            textInputAction: textInputAction,
            label: label,
            keyboardType: TextInputType.number,
            onEditingComplete: onEditingComplete,
            helperText: "Required",
          ),
        );
      },
      initialValue: ValueObject.emptyString(defaultValue.toString()),
      validityListener: (value, valid) {
        onChanged(value);
      },
    );
  }
}
