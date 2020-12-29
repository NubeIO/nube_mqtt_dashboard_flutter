import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';

import '../../../../domain/layout/entities.dart';
import '../../../themes/nube_theme.dart';
import '../../../widgets/responsive/drawer_detail_layout.dart';
import '../../dashboard/widgets/page_screen.dart';

class DemoWidget extends StatelessWidget {
  final List<Widget> actions;

  const DemoWidget({
    Key key,
    this.actions,
  }) : super(key: key);

  static const list = ["Item 1", "Item 2"];
  static const widgets = [
    WidgetEntity.gaugeWidget(
        id: "1",
        topic: "testTopic",
        name: "Gauge Widget",
        config: GaugeConfig(max: 100, min: 0)),
    WidgetEntity.sliderWidget(
        id: "2",
        topic: "testTopic",
        name: "Slider Widget",
        config: SliderConfig(max: 100, min: 0, defaultValue: 0)),
    WidgetEntity.switchWidget(
        id: "3",
        topic: "testTopic",
        name: "Switch Widget",
        config: SwitchConfig(defaultValue: false)),
    WidgetEntity.valueWidget(
        id: "4",
        topic: "testTopic",
        name: "Value Widget",
        config: ValueConfig(unit: "C"))
  ];

  @override
  Widget build(BuildContext context) {
    return DrawerDetailLayout(
      appBarBuilder: (context, index) {
        return AppBar(
          elevation: 4,
          backgroundColor: NubeTheme.backgroundOverlay(context, 4),
          title: Text(list[index]),
          actions: actions,
        );
      },
      detailBuilder: (BuildContext context, int selectedIndex) {
        return WidgetsScreen(
          page: PageEntity(
            id: "1",
            name: "",
            widgets: widgets.toImmutableList(),
          ),
        );
      },
      itemBuilder: (BuildContext context, int index, bool selected,
          void Function(int) onTapCallback) {
        return ListTile(
          selected: selected,
          onTap: () => onTapCallback(index),
          title: Text(list[index]),
        );
      },
      itemCount: list.length,
    );
  }
}
