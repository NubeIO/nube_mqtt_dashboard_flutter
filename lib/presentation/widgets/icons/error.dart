import 'package:flutter/widgets.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../base/custom_icon.dart';

@FramyWidget(groupName: "Icons")
class ErrorIcon extends CustomIcon {
  const ErrorIcon({
    Key key,
    double size,
    Color color,
  }) : super(
            key: key,
            size: size,
            color: color,
            assetName: "assets/icons/ic_close.svg",
            semanticsLabel: "Error");
}
