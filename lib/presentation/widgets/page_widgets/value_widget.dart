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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text(
            value.value.toString(),
            style: textTheme.headline3.copyWith(
              fontSize: 40,
              color: colorScheme.primary,
            ),
          ),
          Text(
            unit,
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
