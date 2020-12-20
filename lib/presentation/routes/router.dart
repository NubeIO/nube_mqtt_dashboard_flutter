import 'package:auto_route/auto_route_annotations.dart';

import '../../domain/session/entities.dart';
import '../pages/connect/connect_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/pin_create/pin_create_page.dart';
import '../pages/pin_validate/pin_validate_page.dart';
import '../pages/splash/splash_page.dart';
import '../rotue_guards/config_guard.dart';

export 'router.gr.dart';

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AdaptiveRoute(page: SplashPage, initial: true),
    AdaptiveRoute<UserType>(page: ValidatePinPage),
    AdaptiveRoute<String>(page: CreatePinPage),
    AdaptiveRoute<bool>(page: ConnectPage),
    AdaptiveRoute(page: DashboardPage, guards: [ConfigGuard]),
  ],
  generateNavigationHelperExtension: true,
)
class $AppRouter {}
