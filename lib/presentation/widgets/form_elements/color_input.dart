import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../themes/nube_theme.dart';
import 'styles/input_types.dart';

class ColorInput extends StatelessWidget {
  final Color currentColor;
  final String label;
  final String helperText;
  final bool isError;
  final bool isEnabled;
  final EdgeInsetsGeometry padding;
  final ValueChanged<Color> _onValueChanged;

  const ColorInput({
    Key key,
    @required this.currentColor,
    @required ValueChanged<Color> onValueChanged,
    @required this.label,
    this.helperText = '',
    this.isError = false,
    this.isEnabled = true,
    this.padding = EdgeInsets.zero,
  })  : _onValueChanged = onValueChanged,
        super(key: key);

  Future<void> _onChange(BuildContext context) async {
    Color pickerColor = currentColor;
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Pick $label color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _onValueChanged(pickerColor);
              Navigator.of(context).pop();
            },
            child: const Text("Select"),
          ),
        ],
      ),
    );
  }

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
        InkWell(
          onTap: isEnabled ? () => _onChange(context) : null,
          child: Padding(
            padding: padding,
            child: Row(
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
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: currentColor,
                    ),
                    height: 32,
                    width: 52,
                  ),
                ),
              ],
            ),
          ),
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
