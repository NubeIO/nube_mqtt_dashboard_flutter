import 'package:flutter/material.dart';

import '../../../application/validation/value_validation_state.dart';
import 'input_statue.dart';
import 'styles/input_types.dart';

class TextInput extends StatelessWidget {
  final ValueValidationState _validationState;
  final ValueChanged<String> _onValueChanged;
  final TextInputAction _textInputAction;
  final VoidCallback _onEditingComplete;
  final TextInputType _keyboardType;
  final String label;
  final String initialValue;
  final String helperText;
  final bool obscureText;

  const TextInput({
    Key key,
    @required this.label,
    this.initialValue,
    this.helperText,
    ValueValidationState validationState,
    ValueChanged<String> onValueChanged,
    TextInputAction textInputAction,
    VoidCallback onEditingComplete,
    TextInputType keyboardType,
    this.obscureText = false,
  })  : _onValueChanged = onValueChanged,
        _validationState = validationState,
        _textInputAction = textInputAction,
        _onEditingComplete = onEditingComplete,
        _keyboardType = keyboardType,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperStyle: InputStyles.smallLabel(context),
          alignLabelWithHint: true,
          labelStyle: InputStyles.regularLabel(context),
          hintStyle: InputStyles.regularLabel(context),
          suffix: buildState(context),
          border: const UnderlineInputBorder(borderSide: BorderSide(width: 2)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        obscureText: obscureText,
        textInputAction: _textInputAction,
        style: InputStyles.textStyle(context),
        autovalidateMode: AutovalidateMode.always,
        onChanged: (value) => _onValueChanged(value),
        validator: (_) => _validationState.getErrorMessage(),
        onEditingComplete: _onEditingComplete,
        keyboardType: _keyboardType);
  }

  Widget buildState(BuildContext context) {
    return InputStateWidget(validationState: _validationState);
  }
}
