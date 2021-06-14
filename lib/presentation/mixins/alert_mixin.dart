import 'package:flutter/material.dart';
import 'package:nube_mqtt_dashboard/presentation/themes/nube_theme.dart';

mixin AlertMixin {
  void showPromptAlert(
    BuildContext context, {
    @required String title,
    @required String actionText,
    @required VoidCallback onAction,
    String subtitle,
    Color color,
  }) {
    final actionStyle = Theme.of(context).textTheme.button;
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 16.0),
          title: Text(
            title,
            style: textTheme.headline1,
          ),
          content: Text(
            subtitle,
            style: textTheme.bodyText1,
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: actionStyle.copyWith(
                    color: NubeTheme.colorText200(context)),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAction();
              },
              child: Text(
                actionText,
                style: actionStyle.copyWith(color: color ?? secondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
