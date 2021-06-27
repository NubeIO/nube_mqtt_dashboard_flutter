import 'package:flutter/material.dart';

class GlobalNavigationKey {
  static final GlobalNavigationKey _globalNavigationKey =
      GlobalNavigationKey._internal();
  final navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext;
  BuildContext get overlayContext =>
      navigatorKey.currentState?.overlay?.context;

  factory GlobalNavigationKey() {
    return _globalNavigationKey;
  }

  GlobalNavigationKey._internal();
}
