import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../constants/app_constants.dart';
import 'nube_theme.dart';
import 'rotue_guards/auth_route_guard.dart';
import 'routes/route_log_observer.dart';
import 'routes/router.dart';
import 'widgets/locale/locale_builder.dart';

@FramyApp(useDevicePreview: true)
class NubeApp extends StatelessWidget {
  const NubeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (context, i18n) {
        return MaterialApp(
          title: AppConstants.APP_NAME,
          theme: NubeTheme.lightTheme,
          localizationsDelegates: [
            i18n,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: i18n.supportedLocales,
          builder: ExtendedNavigator.builder<AppRouter>(
              router: AppRouter(),
              guards: [AuthGuard()],
              observers: [LoggerNavigatorObserver()]),
        );
      },
    );
  }
}
