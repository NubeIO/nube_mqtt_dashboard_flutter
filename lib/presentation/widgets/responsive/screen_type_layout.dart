import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/device_screen_type.dart';
import 'responsive_builder.dart';

class ScreenTypeLayout extends StatelessWidget {
  final Widget mobile;
  @nullable
  final Widget tablet;
  @nullable
  final Widget desktop;

  const ScreenTypeLayout({
    Key key,
    @required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      // If sizing indicates Tablet and we have a tablet widget then return
      if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.landscapeRight,
        // ]);
        return tablet ?? mobile;
      }

      // If sizing indicates desktop and we have a desktop widget then return
      if (sizingInformation.deviceScreenType == DeviceScreenType.Desktop) {
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.landscapeRight,
        // ]);
        return desktop ?? tablet ?? mobile;
      }
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.portraitUp,
      //   DeviceOrientation.portraitDown,
      // ]);
      // Return mobile layout if nothing else is supplied
      return mobile;
    });
  }
}
