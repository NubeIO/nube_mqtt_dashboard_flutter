import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../constants/app_constants.dart';
import 'nube_theme.dart';
import 'widgets/locale/locale_builder.dart';

class NubeApp extends StatelessWidget {
  const NubeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (context, i18n) {
        return MaterialApp(
          title: AppConstants.APP_NAME,
          theme: NubeTheme.lightTheme,
          home: const Placeholder(),
          localizationsDelegates: [
            i18n,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: i18n.supportedLocales,
        );
      },
    );
  }
}
