import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';
import 'package:nube_mqtt_dashboard/domain/layout/layout_repository_interface.dart';

import '../../../../domain/layout/entities.dart' as entities;
import '../../../themes/nube_theme.dart';
import '../../../widgets/responsive/drawer_detail_layout.dart';
import '../../dashboard/widgets/page_screen.dart';

const testTopic = "dashio/test/topic";

class DemoWidget extends StatelessWidget {
  final List<Widget> actions;

  const DemoWidget({
    Key key,
    this.actions,
  }) : super(key: key);

  static const list = ["Item 1", "Item 2"];
  static final widgets = [
    WidgetEntity.gaugeWidget(
      id: "1",
      topic: FlexibleTopic.plain(testTopic),
      name: "Gauge Widget",
      config: const GaugeConfig(max: 100, min: 0),
      globalConfig: GlobalConfig.empty(initial: 0),
    ),
    WidgetEntity.valueWidget(
      id: "4",
      topic: FlexibleTopic.plain(testTopic),
      name: "Value Widget",
      config: const ValueConfig(unit: "C", align: entities.Alignment.left()),
      globalConfig: GlobalConfig.empty(initial: 0),
    ),
    WidgetEntity.failure(
      id: "4",
      topic: FlexibleTopic.plain(testTopic),
      name: "Failure Widget",
      failure: const LayoutParseFailure.unknown(),
      globalConfig: GlobalConfig.empty(),
    ),
    WidgetEntity.sliderWidget(
      id: "2",
      topic: FlexibleTopic.plain(testTopic),
      name: "Slider Widget",
      config: const SliderConfig(
        max: 100,
        min: 0,
        defaultValue: 0,
        step: 0.5,
      ),
      globalConfig: GlobalConfig.empty(initial: 5),
    ),
    WidgetEntity.switchWidget(
      id: "3",
      topic: FlexibleTopic.plain(testTopic),
      name: "Switch Widget",
      config: const SwitchConfig(defaultValue: false),
      globalConfig: GlobalConfig.empty(initial: 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DrawerDetailLayout(
      appBarBuilder: (context, state) => AppBar(
        elevation: 4,
        backgroundColor: NubeTheme.backgroundOverlay(context),
        title: const Text("Demo Page"),
        actions: actions,
      ),
      detailBuilder: WidgetsScreen(
        page: PageEntity(
          id: "1",
          relativePath: "",
          name: "Demo Page",
          config: const Config(protected: false),
          widgets: widgets.toImmutableList(),
          pages: emptyList(),
        ),
      ),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          selected: index == 0,
          onTap: () => Navigator.pop(context),
          title: Text(list[index]),
        );
      },
      itemCount: list.length,
    );
  }
}
