import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../constants/framy_constants.dart';
import 'styles/input_types.dart';

@FramyWidget(groupName: FramyConstants.FORM_INPUTS)
class SwitchInput extends StatelessWidget {
  final bool isCheck;
  final String label;
  final String helperText;
  final bool isError;
  final ValueChanged<bool> _onValueChanged;

  const SwitchInput({
    Key key,
    this.isCheck = false,
    ValueChanged<bool> onValueChanged,
    this.label,
    this.helperText = '',
    this.isError = false,
  })  : _onValueChanged = onValueChanged,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var smallLabel = InputStyles.smallLabel(context);
    if (isError) {
      smallLabel = smallLabel.copyWith(color: Theme.of(context).errorColor);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: InputStyles.textStyle(context))),
            CupertinoSwitch(
              value: isCheck,
              onChanged: (value) => _onValueChanged(value),
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
        if (helperText != null && helperText.isNotEmpty)
          Text(
            helperText,
            style: smallLabel,
          )
      ],
    );
  }
}
