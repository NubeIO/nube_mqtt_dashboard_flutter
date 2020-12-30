import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/widget_data/entities.dart';

class ValueWidget extends StatelessWidget {
  final WidgetData value;
  final String unit;
  const ValueWidget({
    Key key,
    this.value,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          value.value.toString(),
          style: Theme.of(context).textTheme.headline3.copyWith(
                fontSize: 60,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.headline3.copyWith(
                fontSize: Theme.of(context).textTheme.headline1.fontSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }
}
