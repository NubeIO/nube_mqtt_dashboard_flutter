import 'dart:ui';

import 'package:kt_dart/kt.dart';
import 'package:nube_mqtt_dashboard/utils/hex_color.dart';
import 'package:nube_mqtt_dashboard/utils/logger/log.dart';

import '../../../domain/layout/entities.dart';
import '../../../domain/layout/layout_repository_interface.dart';
import '../models/layout.dart';

class LayoutMapper {
  LayoutEntity mapToBuilder(Layout layout) => LayoutEntity(
        config: mapToLayoutEntityConfig(layout.config),
        pages: layout.pages.map(mapToPage).toImmutableList(),
      );

  LayoutEntityConfig mapToLayoutEntityConfig(LayoutConfig config) {
    if (config == null) return LayoutEntityConfig.empty();
    return LayoutEntityConfig(
      persistData: config.persistData,
      showLoading: config.showLoading,
    );
  }

  PageEntity mapToPage(Page element) => PageEntity(
        id: element.id,
        name: element.name,
        config: mapToPageConfig(element.config),
        widgets: element.widgets.map(mapToWidget).toImmutableList(),
      );

  Config mapToPageConfig(PageConfig config) {
    if (config == null) return const Config(protected: false);
    final pageTimeout = config.pageTimeout;
    return Config(
      protected: config.protected,
      timeout: pageTimeout != null
          ? PageTimeout(
              fallbackId: pageTimeout.fallbackId,
              duration: Duration(
                milliseconds: pageTimeout.duration,
              ))
          : null,
    );
  }

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
        },
        MAP: (widget) {
          return WidgetEntity.mapWidget(
            id: widget.id,
            topic: widget.topic,
            name: widget.name,
            config: mapToMapConfig(
              widget.config ?? MapConfigDto.fromJson({}),
            ),
          );
        },
        invalidParse: (value) => WidgetEntity.failure(
          id: widget.id,
          topic: widget.topic,
          name: widget.name,
          failure: const LayoutParseFailure.parse(),
        ),
        unknownWidget: (value) => WidgetEntity.failure(
          id: widget.id,
          topic: widget.topic,
          name: widget.name,
          failure: const LayoutParseFailure.unknown(),
        ),
      );

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
      step: config.step,
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

  MapConfig mapToMapConfig(MapConfigDto config) {
    return MapConfig(
      maps: mapToDoubleKeys(config.maps),
      colors: mapToColorsKeys(config.colors),
    );
  }

  KtMap<double, Color> mapToColorsKeys(Map<String, String> maps) {
    final Map<double, Color> output = {};
    maps.forEach((key, value) {
      try {
        final intKey = double.parse(key);
        output.putIfAbsent(intKey, () => HexColor.parseColor(value));
      } catch (e) {
        Log.e("Skipping mapping for key: $key $value");
      }
    });
    return output.toImmutableMap();
  }

  KtMap<double, String> mapToDoubleKeys(Map<String, String> maps) {
    final Map<double, String> output = {};
    maps.forEach((key, value) {
      try {
        final intKey = double.parse(key);
        output.putIfAbsent(intKey, () => value);
      } catch (e) {
        Log.e("Skipping mapping for key: $key $value");
      }
    });
    return output.toImmutableMap();
  }
}
