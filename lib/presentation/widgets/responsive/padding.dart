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
    final size = MediaQuery.of(context).size.width;
    if (size < 600) {
      return MediaQuery.of(context).orientation == Orientation.portrait ? 4 : 6;
    } else if (size < 800) {
      return MediaQuery.of(context).orientation == Orientation.portrait ? 6 : 8;
    }
    return MediaQuery.of(context).orientation == Orientation.portrait ? 8 : 10;
  }

  static ScreenSize deviceScreenSize(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size.shortestSide;
    final deviceType = MediaQuery.of(context).getDeviceType();
    if (deviceType == DeviceScreenType.Mobile) {
      if (size <= 360) {
        return ScreenSize.small;
      } else if (size <= 400) {
        return ScreenSize.medium;
      } else {
        return ScreenSize.large;
      }
    } else if (deviceType == DeviceScreenType.Tablet) {
      if (size <= 720) {
        return ScreenSize.small;
      } else {
        return ScreenSize.large;
      }
    }
    return ScreenSize.medium;
  }

  static double widgetHeight(BuildContext context) {
    final screenSize = deviceScreenSize(context);

    if (screenSize == ScreenSize.small) {
      return 1;
    } else if (screenSize == ScreenSize.medium) {
      return .9;
    } else {
      return .85;
    }
  }
}

enum PaddingSize { xsmall, small, regular, medium, large, xlarge }

enum ScreenSize { small, medium, large }
