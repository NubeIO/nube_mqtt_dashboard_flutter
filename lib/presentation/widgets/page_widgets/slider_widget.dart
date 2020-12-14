import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/layout/entities.dart';
import '../../../domain/widget_data/entities.dart';

class SliderWidget extends StatelessWidget {
  final WidgetData value;
  final SliderConfig config;
  final void Function(WidgetData value) onChange;

  const SliderWidget({
    Key key,
    this.value,
    this.config,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sliderColor = Theme.of(context).colorScheme.secondary;
    final sliderInactiveColor = Theme.of(context).colorScheme.secondaryVariant;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: sliderColor,
        inactiveTrackColor: sliderInactiveColor,
        trackShape: const RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
        thumbColor: sliderColor,
        overlayColor: sliderColor.withAlpha(32),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
        tickMarkShape: const RoundSliderTickMarkShape(),
        activeTickMarkColor: sliderColor,
        inactiveTickMarkColor: sliderInactiveColor,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: sliderColor,
        valueIndicatorTextStyle: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            value: value.value,
            min: config.min.toDouble(),
            max: config.max.toDouble(),
            divisions: (config.max - config.min) ~/ 10,
            label: '${value.value}',
            onChanged: (value) {
              onChange(WidgetData(value: value));
            },
          ),
          Text(
            value.value.toString(),
            style: Theme.of(context).textTheme.headline3.copyWith(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          )
        ],
      ),
    );
  }
}
