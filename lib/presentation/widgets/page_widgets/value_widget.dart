import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/widget_data/entities.dart';

class ValueWidget extends StatelessWidget {
  final WidgetData value;
  const ValueWidget({
    Key key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value.value.toString(),
      style: Theme.of(context).textTheme.headline3.copyWith(
            fontSize: 60,
            color: Theme.of(context).colorScheme.secondary,
          ),
    );
  }
}
