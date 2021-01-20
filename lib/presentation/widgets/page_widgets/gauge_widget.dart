import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nube_mqtt_dashboard/presentation/widgets/form_elements/styles/input_types.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    final theme = Theme.of(context);
    final min = config.min.toDouble();
    final max = config.max.toDouble();
    final labelStyle = InputStyles.regularLabel(context);
    return Column(
      children: [
        Expanded(
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: min,
                maximum: max,
                canScaleToFit: true,
                showTicks: false,
                startAngle: 150,
                endAngle: 30,
                maximumLabels: 1,
                labelOffset: 32,
                axisLabelStyle: GaugeTextStyle(
                  fontFamily: labelStyle.fontFamily,
                  fontStyle: labelStyle.fontStyle,
                  fontSize: labelStyle.fontSize,
                  fontWeight: labelStyle.fontWeight,
                  color: theme.colorScheme.primary.withOpacity(.6),
                ),
                ranges: <GaugeRange>[
                  GaugeRange(
                    startWidth: 20,
                    endWidth: 20,
                    startValue: min,
                    endValue: max,
                    color: theme.colorScheme.primary.withOpacity(.6),
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    enableAnimation: true,
                    needleLength: .9,
                    value: value.value,
                    needleColor: theme.colorScheme.secondary,
                    knobStyle: KnobStyle(
                      color: theme.colorScheme.secondary,
                    ),
                  )
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      value.value.toString(),
                      style: theme.textTheme.headline3.copyWith(
                        fontSize: theme.textTheme.headline1.fontSize,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 0,
        )
      ],
    );
  }
}
