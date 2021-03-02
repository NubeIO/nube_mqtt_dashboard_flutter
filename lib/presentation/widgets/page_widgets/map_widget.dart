import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nube_mqtt_dashboard/domain/layout/entities.dart';

import '../../../domain/widget_data/entities.dart';

class MapWidget extends StatelessWidget {
  final WidgetData value;
  final MapConfig config;
  final String errorValue;

  const MapWidget({
    Key key,
    @required this.value,
    @required this.config,
    this.errorValue = "Invalid",
  }) : super(key: key);

  String getValue() {
    return config.maps[value.value] ?? errorValue;
  }

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
            getValue(),
            style: textTheme.headline3.copyWith(
              fontSize: config.fontSize ?? 40,
              color: config.colors[value.value] ?? colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
