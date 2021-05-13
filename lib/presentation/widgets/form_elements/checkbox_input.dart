import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../constants/framy_constants.dart';
import '../../themes/nube_theme.dart';
import 'styles/input_types.dart';

@FramyWidget(groupName: FramyConstants.FORM_INPUTS)
class SwitchInput extends StatelessWidget {
  final bool isCheck;
  final String label;
  final String helperText;
  final bool isError;
  final bool isEnabled;
  final ValueChanged<bool> _onValueChanged;

  const SwitchInput({
    Key key,
    this.isCheck = false,
    ValueChanged<bool> onValueChanged,
    this.label,
    this.helperText = '',
    this.isError = false,
    this.isEnabled = true,
  })  : _onValueChanged = onValueChanged,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var smallLabel = InputStyles.smallLabel(context);
    if (isError) {
      smallLabel =
          smallLabel.copyWith(color: Theme.of(context).colorScheme.error);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              label,
              style: InputStyles.textStyle(context).copyWith(
                color: isEnabled
                    ? Theme.of(context).colorScheme.onBackground
                    : NubeTheme.colorText300(context),
              ),
            )),
            CupertinoSwitch(
              value: isCheck,
              onChanged: isEnabled ? (value) => _onValueChanged(value) : null,
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
