import 'package:auto_route/auto_route_annotations.dart';

import '../pages/connect/connect_page.dart';
import '../pages/pin_create/pin_create_page.dart';
import '../pages/pin_validate/pin_validate_page.dart';
import '../pages/splash/splash_page.dart';
import '../rotue_guards/auth_route_guard.dart';

export 'router.gr.dart';

@AdaptiveAutoRouter(routes: <AutoRoute>[
  AdaptiveRoute(page: SplashPage, initial: true),
  AdaptiveRoute(page: ConnectPage, guards: [AuthGuard]),
  AdaptiveRoute(page: ValidatePinPage),
  AdaptiveRoute(page: CreatePinPage),
])
class $AppRouter {}
