import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/device_screen_type.dart';

extension MediaQueryEx on MediaQueryData {
  DeviceScreenType getDeviceType() {
    final deviceWidth = size.shortestSide;

    if (deviceWidth > 950) {
      return DeviceScreenType.Desktop;
    }

    if (deviceWidth > 600) {
      return DeviceScreenType.Tablet;
    }

    return DeviceScreenType.Mobile;
  }
}
