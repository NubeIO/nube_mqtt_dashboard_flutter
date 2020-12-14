import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/layout/entities.dart';
import '../../../domain/widget_data/entities.dart';

class SwitchWidget extends StatelessWidget {
  final WidgetData value;
  final SwitchConfig config;
  final void Function(WidgetData value) onChange;

  const SwitchWidget({
    Key key,
    this.value,
    this.config,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      activeColor: Theme.of(context).colorScheme.secondary,
      onChanged: (bool value) {
        onChange(WidgetData(value: fromValue(value: value)));
      },
      value: value.value == 1,
    );
  }

  static double fromValue({bool value}) => value ? 1 : 0;
}
