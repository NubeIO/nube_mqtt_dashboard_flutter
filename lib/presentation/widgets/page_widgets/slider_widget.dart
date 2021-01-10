import 'dart:math';

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

  void _onDecrease() {
    onChange(WidgetData(value: value.value - .1));
  }

  void _onIncrease() {
    onChange(WidgetData(value: value.value + .1));
  }

  @override
  Widget build(BuildContext context) {
    final sliderColor = Theme.of(context).colorScheme.secondary;
    final sliderInactiveColor = Theme.of(context).colorScheme.secondaryVariant;
    final min = config.min.toDouble();
    final max = config.max;
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: value.value <= min ? null : _onDecrease,
              ),
              Expanded(
                child: Slider(
                  value: value.value,
                  min: min,
                  max: max.toDouble(),
                  label: '${value.value}',
                  onChanged: (value) {
                    onChange(WidgetData(value: value));
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: value.value >= max ? null : _onIncrease,
              ),
            ],
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
