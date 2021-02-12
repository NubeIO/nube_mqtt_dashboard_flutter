import 'package:flutter/material.dart';
import 'package:nube_mqtt_dashboard/domain/layout/entities.dart';
import 'package:nube_mqtt_dashboard/domain/widget_data/entities.dart';
import 'package:nube_mqtt_dashboard/presentation/widgets/responsive/padding.dart';

class SwitchGroupWidget extends StatelessWidget {
  final WidgetData value;
  final SwitchGroupConfig config;
  final void Function(WidgetData value) onChange;

  const SwitchGroupWidget({
    Key key,
    this.value,
    this.config,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = config.items.asList();
    return Align(
      alignment: const FractionalOffset(0.5, 0.1),
      child: ToggleButtons(
        borderRadius: BorderRadius.all(
          Radius.circular(ResponsiveSize.padding(
            context,
            size: PaddingSize.xsmall,
          )),
        ),
        onPressed: (index) {
          onChange(WidgetData(value: config.items[index].value));
        },
        isSelected: [
          ...options.map(
            (option) => option.value == value.value,
          ),
        ],
        color: Theme.of(context).colorScheme.onSurface.withOpacity(.6),
        fillColor: Theme.of(context).colorScheme.secondary,
        selectedColor: Theme.of(context).colorScheme.onSecondary,
        textStyle: Theme.of(context).textTheme.button,
        children: [
          ...options.map(
            (option) => Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                option.name,
              ),
            ),
          )
        ],
      ),
    );
  }
}
