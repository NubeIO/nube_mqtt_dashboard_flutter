import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/widget_data/entities.dart';

class MapWidget extends StatelessWidget {
  final WidgetData value;
  final KtMap<double, String> maps;
  final KtMap<double, Color> colors;
  final String errorValue;

  const MapWidget({
    Key key,
    @required this.value,
    @required this.maps,
    @required this.colors,
    this.errorValue = "Invalid",
  }) : super(key: key);

  String getValue() {
    return maps[value.value] ?? errorValue;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text(
            getValue(),
            style: textTheme.headline3.copyWith(
              fontSize: 40,
              color: colors[value.value] ?? colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
