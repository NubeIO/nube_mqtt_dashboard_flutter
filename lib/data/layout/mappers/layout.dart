import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:nube_mqtt_dashboard/domain/theme/entities.dart';
import 'package:nube_mqtt_dashboard/utils/hex_color.dart';
import 'package:nube_mqtt_dashboard/utils/logger/log.dart';

import '../../../domain/layout/entities.dart';
import '../../../domain/layout/layout_repository_interface.dart';
import '../models/layout.dart';

class LayoutMapper {
  LayoutEntity mapToBuilder(Layout layout) => LayoutEntity(
        config: mapToLayoutEntityConfig(layout.config),
        logo: mapToLogo(layout.logo),
        pages: layout.pages
            .map((page) => mapToPage(
                  page,
                  layout.widgetConfig ?? GlobalWidgetConfigDto.empty(),
                ))
            .toImmutableList(),
      );

  Logo mapToLogo(LogoConfig logo) {
    if (logo == null) return Logo.empty();
    return Logo(
      size: logo.size,
      showIcon: logo.showIcon,
      dark: mapToLogoItem(logo.dark),
      light: mapToLogoItem(logo.light),
    );
  }

  LogoItem mapToLogoItem(LogoItemDto item) {
    if (item == null) return LogoItem.empty();
    return LogoItem(
      smallUrl: item.small,
      largeUrl: item.large,
    );
  }

  LayoutEntityConfig mapToLayoutEntityConfig(LayoutConfig config) {
    if (config == null) return LayoutEntityConfig.empty();
    return LayoutEntityConfig(
      persistData: config.persistData,
      showLoading: config.showLoading,
    );
  }

  PageEntity mapToPage(
    Page element,
    GlobalWidgetConfigDto globalWidgetConfig,
  ) =>
      PageEntity(
        id: element.id,
        name: element.name,
        config: mapToPageConfig(element.config),
        widgets: element.widgets
            .map(
              (widget) => mapToWidget(
                widget,
                globalConfig: globalWidgetConfig,
                pageConfig:
                    element.widgetConfig ?? GlobalWidgetConfigDto.empty(),
              ),
            )
            .toImmutableList(),
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

  WidgetEntity mapToWidget(
    Widget widget, {
    GlobalWidgetConfigDto globalConfig,
    GlobalWidgetConfigDto pageConfig,
  }) =>
      widget.map(
        GAUGE: (widget) {
          final config = widget.config ?? GaugeConfigDto.fromJson({});
          return WidgetEntity.gaugeWidget(
            id: widget.id,
            topic: mapToFlexibleTopic(widget.topic),
            name: widget.name,
            config: mapToGaugeConfig(
              config,
            ),
            globalConfig: mapToGlobalConfig(
              widget.config,
              global: globalConfig,
              page: pageConfig,
            ),
          );
        },
        SWITCH: (widget) => WidgetEntity.switchWidget(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          config: mapToSwitchConfig(
            widget.config ?? SwitchConfigDto.fromJson({}),
          ),
          globalConfig: mapToGlobalConfig(
            widget.config,
            global: globalConfig,
            page: pageConfig,
          ),
        ),
        SLIDER: (widget) => WidgetEntity.sliderWidget(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          config: mapToSliderConfig(
            widget.config ?? SliderConfigDto.fromJson({}),
          ),
          globalConfig: mapToGlobalConfig(
            widget.config,
            global: globalConfig,
            page: pageConfig,
          ),
        ),
        VALUE: (widget) => WidgetEntity.valueWidget(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          config: mapToValueConfig(
            widget.config ?? ValueConfigDto.fromJson({}),
          ),
          globalConfig: mapToGlobalConfig(
            widget.config,
            global: globalConfig,
            page: pageConfig,
          ),
        ),
        SWITCH_GROUP: (widget) {
          return WidgetEntity.switchGroupWidget(
            id: widget.id,
            topic: mapToFlexibleTopic(widget.topic),
            name: widget.name,
            config: mapToSwitchGroupConfig(
              widget.config ?? SwitchGroupConfigDto.fromJson({}),
            ),
            globalConfig: mapToGlobalConfig(
              widget.config,
              global: globalConfig,
              page: pageConfig,
            ),
          );
        },
        MAP: (widget) {
          return WidgetEntity.mapWidget(
            id: widget.id,
            topic: mapToFlexibleTopic(widget.topic),
            name: widget.name,
            config: mapToMapConfig(
              widget.config ?? MapConfigDto.fromJson({}),
            ),
            globalConfig: mapToGlobalConfig(
              widget.config,
              global: globalConfig,
              page: pageConfig,
            ),
          );
        },
        invalidParse: (value) => WidgetEntity.failure(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          failure: const LayoutParseFailure.parse(),
          globalConfig: mapToGlobalConfig(
            const WidgetConfigDto.emptyConfig(),
            global: globalConfig,
            page: pageConfig,
          ),
        ),
        unknownWidget: (value) => WidgetEntity.failure(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          failure: const LayoutParseFailure.unknown(),
          globalConfig: mapToGlobalConfig(
            const WidgetConfigDto.emptyConfig(),
            global: globalConfig,
            page: pageConfig,
          ),
        ),
      );

  FlexibleTopic mapToFlexibleTopic(FlexibleTopicDto topic) {
    return FlexibleTopic(
      read: topic.read,
      write: topic.write,
    );
  }

  GlobalConfig mapToGlobalConfig(
    WidgetConfigDto config, {
    @required GlobalWidgetConfigDto global,
    @required GlobalWidgetConfigDto page,
  }) {
    return GlobalConfig(
        background: mapToBackground(
          config.background,
          global: global.background,
          page: page.background,
        ),
        title: mapToTitle(
          config.title,
          global: global.title,
          page: page.title,
        ));
  }

  BackgroundConfig mapToBackground(
    BackgroundConfigDto widget, {
    @required BackgroundConfigDto global,
    @required BackgroundConfigDto page,
  }) {
    final background = widget ?? page ?? global;
    if (background == null) return BackgroundConfig.empty();
    return BackgroundConfig(
      color: HexColor.parseColor(background.color),
      colors: mapToColorsKeys(background.colors ?? {}),
    );
  }

  TitleConfig mapToTitle(
    TitleConfigDto widget, {
    @required TitleConfigDto global,
    @required TitleConfigDto page,
  }) {
    final title = widget ?? page ?? global;
    if (title == null) return TitleConfig.empty();
    return TitleConfig(
      fontSize: title.fontSize,
      align: mapToAlignment(title.align),
      color: HexColor.parseColor(title.color),
    );
  }

  Alignment mapToAlignment(
    AlignmentType type, {
    Alignment fallback = const Alignment.left(),
  }) {
    switch (type) {
      case AlignmentType.CENTER:
        return const Alignment.center();
      case AlignmentType.LEFT:
        return const Alignment.left();
      case AlignmentType.RIGHT:
        return const Alignment.right();
    }
    return fallback;
  }

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
