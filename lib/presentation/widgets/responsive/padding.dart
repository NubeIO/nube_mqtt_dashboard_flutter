import 'dart:math';

import 'package:flutter/material.dart';

import '../../extensions/device_screen_type.dart';
import '../../models/device_screen_type.dart';

const GOLDEN_RATIO = 0.61;

class ResponsiveSize {
  static double padding(
    BuildContext context, {
    PaddingSize size = PaddingSize.regular,
  }) {
    final deviceType = MediaQuery.of(context).getDeviceType();
    switch (deviceType) {
      case DeviceScreenType.Mobile:
        return _paddingForMobile(size);
        break;
      default:
        return _paddingForTablet(size);
    }
  }

  static double panelWidth(BuildContext context) {
    final deviceType = MediaQuery.of(context).getDeviceType();
    switch (deviceType) {
      case DeviceScreenType.Mobile:
        return MediaQuery.of(context).size.width;
        break;
      default:
        return min(MediaQuery.of(context).size.width * GOLDEN_RATIO, 500);
    }
  }

  static double _paddingForMobile(PaddingSize size) {
    switch (size) {
      case PaddingSize.xsmall:
        return 4.0;
      case PaddingSize.small:
        return 8.0;
      case PaddingSize.regular:
        return 16.0;
      case PaddingSize.medium:
        return 24.0;
      case PaddingSize.large:
        return 32.0;
      case PaddingSize.xlarge:
        return 64.0;
    }
    return 16.0;
  }

  static double _paddingForTablet(PaddingSize size) {
    switch (size) {
      case PaddingSize.xsmall:
        return 8.0;
      case PaddingSize.small:
        return 16.0;
      case PaddingSize.regular:
        return 24.0;
      case PaddingSize.medium:
        return 40.0;
      case PaddingSize.large:
        return 56.0;
      case PaddingSize.xlarge:
        return 78.0;
    }
    return 16.0;
  }
}

enum PaddingSize { xsmall, small, regular, medium, large, xlarge }
