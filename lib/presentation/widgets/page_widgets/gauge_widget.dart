import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gauge/flutter_gauge.dart';

import '../../../domain/layout/entities.dart';
import '../../../domain/widget_data/entities.dart';

class GaugeWidget extends StatelessWidget {
  final WidgetData value;
  final GaugeConfig config;
  final void Function(WidgetData value) onChange;

  const GaugeWidget({
    Key key,
    this.value,
    this.config,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterGauge(
      index: value.value,
      start: config.min,
      end: config.max,
      number: Number.endAndCenterAndStart,
      secondsMarker: SecondsMarker.none,
      circleColor: Theme.of(context).colorScheme.secondary,
      handColor: Theme.of(context).colorScheme.primary,
      indicatorColor: Theme.of(context).colorScheme.primary,
      counterStyle: Theme.of(context).textTheme.headline3.copyWith(
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
      textStyle: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
    );
  }
}
