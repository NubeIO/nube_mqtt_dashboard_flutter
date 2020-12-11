import 'package:kt_dart/kt.dart';

import '../../../domain/layout/entities.dart';
import '../models/layout.dart';

class LayoutMapper {
  LayoutBuilder mapToBuilder(Layout layout) => LayoutBuilder(
        pages: layout.pages.map(mapToPage).toImmutableList(),
      );

  PageEntity mapToPage(Page element) => PageEntity(
        id: element.id,
        name: element.name,
        widgets: element.widgets.map(mapToWidget).toImmutableList(),
      );

  WidgetEntity mapToWidget(Widget widget) => widget.map(
      GAUGE: (widget) => WidgetEntity.gaugeWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: mapToGaugeConfig(widget.config),
          ),
      SWITCH: (widget) => WidgetEntity.switchWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: mapToSwitchConfig(widget.config),
          ),
      SLIDER: (widget) => WidgetEntity.sliderWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: mapToSliderConfig(widget.config),
          ),
      VALUE: (value) => WidgetEntity.valueWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: const EmptyConfig(),
          ));

  GaugeConfig mapToGaugeConfig(GaugeConfigDto config) {
    return GaugeConfig(
      min: config.min,
      max: config.max,
    );
  }

  SwitchConfig mapToSwitchConfig(SwitchConfigDto config) {
    return SwitchConfig(
      defaultValue: config.defaultValue,
    );
  }

  SliderConfig mapToSliderConfig(SliderConfigDto config) {
    return SliderConfig(
      min: config.min,
      max: config.max,
      defaultValue: config.defaultValue,
    );
  }
}
