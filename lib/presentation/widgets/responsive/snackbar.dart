import 'package:flutter/material.dart';

import '../../extensions/device_screen_type.dart';
import '../../models/device_screen_type.dart';
import 'padding.dart';

class ResponsiveSnackbar extends SnackBar {
  const ResponsiveSnackbar._create({
    @required Widget content,
    @required EdgeInsetsGeometry margin,
  }) : super(
          content: content,
          behavior: SnackBarBehavior.floating,
          margin: margin,
        );

  static double snackbarMargin(
    BuildContext context,
  ) {
    final deviceType = MediaQuery.of(context).getDeviceType();
    final width = MediaQuery.of(context).size.width;
    switch (deviceType) {
      case DeviceScreenType.Mobile:
        return width;
        break;
      default:
        return width - ResponsiveSize.panelWidth(context);
    }
  }

  factory ResponsiveSnackbar.build(
    BuildContext context, {
    @required Widget content,
    Direction direction = Direction.right,
    double width,
  }) {
    final deviceType = MediaQuery.of(context).getDeviceType();
    final marginLeft = width ?? ResponsiveSnackbar.snackbarMargin(context);
    final elseMargin = ResponsiveSize.padding(context);

    return ResponsiveSnackbar._create(
      content: content,
      margin: deviceType == DeviceScreenType.Mobile
          ? EdgeInsets.all(elseMargin)
          : EdgeInsets.only(
              left: direction == Direction.right
                  ? marginLeft + elseMargin
                  : elseMargin,
              right: direction == Direction.right
                  ? elseMargin
                  : marginLeft + elseMargin,
              bottom: elseMargin,
            ),
    );
  }
}

enum Direction { left, right }
