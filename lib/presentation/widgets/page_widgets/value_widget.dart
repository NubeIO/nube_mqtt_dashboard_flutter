import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nube_mqtt_dashboard/domain/layout/entities.dart';

import '../../../domain/widget_data/entities.dart';

class ValueWidget extends StatelessWidget {
  final WidgetData value;
  final ValueConfig config;
  const ValueWidget({
    Key key,
    this.value,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final alignment = config.align.when(
      center: () => MainAxisAlignment.center,
      left: () => MainAxisAlignment.start,
      right: () => MainAxisAlignment.end,
    );
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: alignment,
        children: [
          Text(
            value.value.toString(),
            style: textTheme.headline3.copyWith(
              fontSize: config.fontSize ?? 40,
              color: colorScheme.primary,
            ),
          ),
          Text(
            config.unit,
            style: textTheme.headline3.copyWith(
              fontSize: textTheme.headline1.fontSize,
              color: colorScheme.primary.withOpacity(.6),
            ),
          ),
        ],
      ),
    );
  }
}
