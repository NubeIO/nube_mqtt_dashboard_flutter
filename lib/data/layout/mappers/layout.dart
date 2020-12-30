import 'package:kt_dart/kt.dart';

import '../../../domain/layout/entities.dart';
import '../models/layout.dart';

class LayoutMapper {
  LayoutEntity mapToBuilder(Layout layout) => LayoutEntity(
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
            config: mapToGaugeConfig(
              widget.config ?? GaugeConfigDto.fromJson({}),
            ),
          ),
      SWITCH: (widget) => WidgetEntity.switchWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: mapToSwitchConfig(
              widget.config ?? SwitchConfigDto.fromJson({}),
            ),
          ),
      SLIDER: (widget) => WidgetEntity.sliderWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: mapToSliderConfig(
              widget.config ?? SliderConfigDto.fromJson({}),
            ),
          ),
      VALUE: (widget) => WidgetEntity.valueWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: mapToValueConfig(
              widget.config ?? ValueConfigDto.fromJson({}),
            ),
          ),
      SWITCH_GROUP: (widget) {
        return WidgetEntity.switchGroupWidget(
          id: widget.id,
          topic: widget.topic,
          name: widget.name,
          config: mapToSwitchGroupConfig(
            widget.config ?? SwitchGroupConfigDto.fromJson({}),
          ),
        );
      });

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

  ValueConfig mapToValueConfig(ValueConfigDto config) {
    return ValueConfig(
      unit: config.unit,
    );
  }

  SwitchGroupConfig mapToSwitchGroupConfig(SwitchGroupConfigDto config) {
    return SwitchGroupConfig(
      items: config.items.map(mapToButtonGroupItem).toImmutableList(),
      defaultValue: config.defaultValue,
    );
  }

  SwitchGroupItem mapToButtonGroupItem(SwitchGroupItemDto item) {
    return SwitchGroupItem(
      id: item.id,
      name: item.name,
      value: item.value,
    );
  }
}
