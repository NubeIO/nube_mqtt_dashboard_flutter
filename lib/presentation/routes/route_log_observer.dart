import 'package:flutter/widgets.dart';

import '../../utils/logger/log.dart';

class LoggerNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    Log.i(
        "Navigated from ${previousRoute?.settings?.name ?? 'Start'} to ${route?.settings?.name ?? 'End'}");
  }
}
