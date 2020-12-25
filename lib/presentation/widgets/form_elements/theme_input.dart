import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../constants/framy_constants.dart';
import '../../themes/theme_interface.dart';
import '../theme_painter.dart';
import 'styles/input_types.dart';

@FramyWidget(groupName: FramyConstants.FORM_INPUTS)
class ThemeInput extends StatelessWidget {
  final ITheme currentTheme;
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry padding;

  const ThemeInput({
    Key key,
    this.currentTheme,
    this.onTap,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
                child: Text(
              "Theme (${currentTheme.name})",
              style: InputStyles.textStyle(context),
            )),
            CustomPaint(
              painter: ThemePainer(
                currentTheme.primary,
                currentTheme.background,
                currentTheme.secondary,
              ),
              size: const Size(32, 32),
            ),
          ],
        ),
      ),
    );
  }
}
