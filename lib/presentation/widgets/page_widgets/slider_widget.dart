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
    onChange(WidgetData(value: value.value - config.step));
  }

  void _onIncrease() {
    onChange(WidgetData(value: value.value + config.step));
  }

  @override
  Widget build(BuildContext context) {
    final sliderColor = Theme.of(context).colorScheme.primary;
    final sliderInactiveColor =
        Theme.of(context).colorScheme.primary.withOpacity(.6);
    final minConfig = config.min.toDouble();
    final maxConfig = config.max.toDouble();
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
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Stack(
          children: [
            Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: value.value <= minConfig ? null : _onDecrease,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 32,
                  right: 32,
                  child: Slider(
                    value: value.value,
                    min: min(minConfig, value.value),
                    max: max(maxConfig, value.value),
                    label: '${value.value}',
                    onChanged: (value) {
                      onChange(WidgetData(value: value));
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: value.value >= maxConfig ? null : _onIncrease,
                  ),
                ),
              ],
            ),
            Center(
              child: Transform.translate(
                offset: const Offset(0, 24),
                child: Text(
                  value.value.toString(),
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
