import 'package:flutter/widgets.dart';

import '../../../generated/i18n.dart';

typedef LocaleWidgetBuilder = Widget Function(
    BuildContext context, GeneratedLocalizationsDelegate i18n);

class LocaleBuilder extends StatefulWidget {
  final LocaleWidgetBuilder _builder;
  const LocaleBuilder({Key key, LocaleWidgetBuilder builder})
      : _builder = builder,
        super(key: key);

  @override
  LocaleBuilderState createState() => LocaleBuilderState();
}

class LocaleBuilderState extends State<LocaleBuilder> {
  final i18n = I18n.delegate;

  @override
  void initState() {
    super.initState();
    I18n.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(context, i18n);
  }
}
