import 'package:flutter/material.dart';
import 'package:nube_mqtt_dashboard/presentation/widgets/responsive/snackbar.dart';

mixin MessageMixin {
  void onFailureMessage(BuildContext context, String message) {
    final snackbar = ResponsiveSnackbar.build(
      context,
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
