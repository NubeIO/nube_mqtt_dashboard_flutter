import 'dart:math';

import 'package:flutter/material.dart';

import '../../extensions/device_screen_type.dart';
import '../../models/device_screen_type.dart';

const GOLDEN_RATIO = 0.61;
const GOLDEN_RATIO_SMALL = 0.244;
const _MASTER_PANEL_WIDTH = 300.0;

// ignore: avoid_classes_with_only_static_members
class ResponsiveSize {
  // ignore: non_constant_identifier_names
  static double MASTER_PANEL_WIDTH = _MASTER_PANEL_WIDTH;

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

  static double twoWidth(BuildContext context) {
    final deviceType = MediaQuery.of(context).getDeviceType();
    switch (deviceType) {
      case DeviceScreenType.Mobile:
        return MediaQuery.of(context).size.width;
        break;
      default:
        return min(
            MediaQuery.of(context).size.width *
                (GOLDEN_RATIO + GOLDEN_RATIO_SMALL),
            800);
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

  static int widgetsCrossAxisCount(
    BuildContext context,
    DeviceScreenType screenType,
  ) {
    int count = 1;
    switch (screenType) {
      case DeviceScreenType.Mobile:
        count = 1;
        break;
      default:
        final totalWidth = MediaQuery.of(context).size.width;
        final availableWidth = totalWidth - MASTER_PANEL_WIDTH;
        count = availableWidth ~/ MASTER_PANEL_WIDTH;
    }
    if (count <= 0) {
      return 1;
    } else {
      return count;
    }
  }
}

enum PaddingSize { xsmall, small, regular, medium, large, xlarge }
