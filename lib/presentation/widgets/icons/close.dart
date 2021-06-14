import 'package:flutter/widgets.dart';

import '../base/custom_icon.dart';

class CloseIcon extends CustomIcon {
  const CloseIcon({
    Key key,
    double size,
    Color color,
  }) : super(
            key: key,
            size: size,
            color: color,
            assetName: "assets/icons/ic_close.svg",
            semanticsLabel: "Close");
}
