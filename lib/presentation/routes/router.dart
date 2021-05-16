import 'package:auto_route/auto_route_annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:nube_mqtt_dashboard/presentation/pages/onboarding/on_boarding_page.dart';
import 'package:nube_mqtt_dashboard/presentation/pages/verification/verification_page.dart';

import '../pages/connect/connect_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/logs/logs_page.dart';
import '../pages/pin_create/pin_create_page.dart';
import '../pages/pin_validate/pin_validate_page.dart';
import '../pages/preview/preview_page.dart';
import '../pages/splash/splash_page.dart';
import '../rotue_guards/config_guard.dart';

export 'router.gr.dart';

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AdaptiveRoute(page: SplashPage, initial: true),
    AdaptiveRoute(page: OnBoardingPage),
    AdaptiveRoute(page: VerificationPage),
    AdaptiveRoute<Unit>(page: ValidatePinPage),
    AdaptiveRoute<String>(page: CreatePinPage),
    AdaptiveRoute<bool>(page: ConnectPage),
    AdaptiveRoute(page: DashboardPage, guards: [ConfigGuard]),
    AdaptiveRoute(page: PreviewPage),
    AdaptiveRoute(page: LogsPage),
  ],
  generateNavigationHelperExtension: true,
)
class $AppRouter {}
