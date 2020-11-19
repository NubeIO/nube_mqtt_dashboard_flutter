import 'package:flutter/widgets.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../base/custom_icon.dart';

@FramyWidget(groupName: "Icons")
class SuccessIcon extends CustomIcon {
  const SuccessIcon({
    Key key,
    double size,
    Color color,
  }) : super(
            key: key,
            size: size,
            color: color,
            assetName: "assets/icons/ic_check.svg",
            semanticsLabel: "Success");
}
