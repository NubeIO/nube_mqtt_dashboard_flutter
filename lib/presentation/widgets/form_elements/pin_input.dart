import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:framy_annotation/framy_annotation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/framy_constants.dart';
import '../../nube_theme.dart';

@FramyWidget(groupName: FramyConstants.FORM_INPUTS)
class PinInput extends StatelessWidget {
  final ValueChanged<String> _onValueChanged;
  final VoidCallback _onEditingComplete;

  const PinInput({
    Key key,
    @required ValueChanged<String> onValueChanged,
    VoidCallback onEditingComplete,
  })  : _onValueChanged = onValueChanged,
        _onEditingComplete = onEditingComplete,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.bold,
      ),
      length: AppConstants.PIN_LENGTH,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        borderRadius: BorderRadius.circular(5),
        inactiveColor: NubeTheme.lightColorText200,
        activeColor: NubeTheme.lightColorText200,
        selectedColor: Theme.of(context).accentColor,
        activeFillColor: Theme.of(context).scaffoldBackgroundColor,
        selectedFillColor: Theme.of(context).scaffoldBackgroundColor,
        inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
        fieldHeight: 60,
        fieldWidth: 50,
      ),
      showCursor: false,
      enableActiveFill: true,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: Theme.of(context).textTheme.headline1,
      keyboardType: TextInputType.number,
      onCompleted: (v) {
        if (_onEditingComplete != null) _onEditingComplete();
      },
      onChanged: (value) {
        _onValueChanged(value);
      },
      beforeTextPaste: (text) {
        return false;
      },
    );
  }
}
