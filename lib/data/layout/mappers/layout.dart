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
            .map((page) => mapToPage(page, layout.widgetConfig))
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
                globalConfig:
                    globalWidgetConfig ?? GlobalWidgetConfigDto.empty(),
                pageConfig:
                    element?.widgetConfig ?? GlobalWidgetConfigDto.empty(),
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
          return WidgetEntity.gaugeWidget(
            id: widget.id,
            topic: mapToFlexibleTopic(widget.topic),
            name: widget.name,
            config: mapToGaugeConfig(
              widget.config,
              global: globalConfig.widget?.gaugeConfig,
              page: pageConfig.widget?.gaugeConfig,
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
            widget.config,
            global: globalConfig.widget?.switchConfig,
            page: pageConfig.widget?.switchConfig,
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
            widget.config,
            global: globalConfig.widget?.sliderConfig,
            page: pageConfig.widget?.sliderConfig,
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
            widget.config,
            global: globalConfig.widget?.valueConfig,
            page: pageConfig.widget?.valueConfig,
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
              widget.config,
              global: globalConfig.widget?.switchGroupConfig,
              page: pageConfig.widget?.switchGroupConfig,
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
              widget.config,
              global: globalConfig?.widget?.mapConfig,
              page: pageConfig?.widget?.mapConfig,
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
        config?.background,
        global: global?.background,
        page: page?.background,
      ),
      title: mapToTitle(
        config?.title,
        global: global?.title,
        page: page?.title,
      ),
      initial: config?.initial ?? page?.initial ?? global?.initial,
    );
  }

  BackgroundConfig mapToBackground(
    BackgroundConfigDto widget, {
    @required BackgroundConfigDto global,
    @required BackgroundConfigDto page,
  }) {
    final background = widget ?? page ?? global;
    if (background == null) return BackgroundConfig.empty();
    return BackgroundConfig(
      color: HexColor.parseColor(widget?.color ?? page?.color ?? global?.color),
      colors: mapToColorsKeys(
          widget?.colors ?? page?.colors ?? global?.colors ?? {}),
    );
  }

  TitleConfig mapToTitle(
    TitleConfigDto widget, {
    @required TitleConfigDto global,
    @required TitleConfigDto page,
  }) {
    final hexColor = widget?.color ?? page?.color ?? global?.color;
    return TitleConfig(
      fontSize: widget?.fontSize ?? page?.fontSize ?? global?.fontSize,
      align: mapToAlignment(
        widget?.align ?? page?.align ?? global?.align,
      ),
      color: hexColor != null ? HexColor.parseColor(hexColor) : null,
      colors: mapToColorsKeys(
          widget?.colors ?? page?.colors ?? global?.colors ?? {}),
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

  GaugeConfig mapToGaugeConfig(
    GaugeConfigDto widget, {
    @required GaugeConfigDto global,
    @required GaugeConfigDto page,
  }) {
    return GaugeConfig(
      min: widget?.min ?? page?.min ?? global?.min ?? 0,
      max: widget?.max ?? page?.max ?? global?.max ?? 100,
    );
  }

  SwitchConfig mapToSwitchConfig(
    SwitchConfigDto widget, {
    @required SwitchConfigDto global,
    @required SwitchConfigDto page,
  }) {
    return SwitchConfig(
      defaultValue: widget?.defaultValue ??
          page?.defaultValue ??
          global?.defaultValue ??
          false,
    );
  }

  SliderConfig mapToSliderConfig(
    SliderConfigDto widget, {
    @required SliderConfigDto global,
    @required SliderConfigDto page,
  }) {
    return SliderConfig(
      min: widget?.min ?? page?.min ?? global?.min ?? 0,
      max: widget?.max ?? page?.max ?? global?.max ?? 100,
      step: widget?.step ?? page?.step ?? global?.step ?? 1,
      defaultValue: widget?.defaultValue ??
          page?.defaultValue ??
          global?.defaultValue ??
          0,
    );
  }

  ValueConfig mapToValueConfig(
    ValueConfigDto widget, {
    @required ValueConfigDto global,
    @required ValueConfigDto page,
  }) {
    return ValueConfig(
      unit: widget?.unit ?? page?.unit ?? global?.unit ?? "",
      align: mapToAlignment(
        widget?.align ?? page?.align ?? global?.align,
      ),
      fontSize: widget?.fontSize ?? page?.fontSize ?? global?.fontSize,
    );
  }

  SwitchGroupConfig mapToSwitchGroupConfig(
    SwitchGroupConfigDto widget, {
    @required SwitchGroupConfigDto global,
    @required SwitchGroupConfigDto page,
  }) {
    return SwitchGroupConfig(
      items: (widget?.items ?? page?.items ?? global?.items ?? [])
          .map(mapToButtonGroupItem)
          .toImmutableList(),
      defaultValue: widget?.defaultValue ??
          page?.defaultValue ??
          global?.defaultValue ??
          0,
    );
  }

  MapConfig mapToMapConfig(
    MapConfigDto widget, {
    @required MapConfigDto global,
    @required MapConfigDto page,
  }) {
    return MapConfig(
      maps: mapToDoubleKeys(
        widget?.maps ?? page?.maps ?? global?.maps ?? {},
      ),
      colors: mapToColorsKeys(
        widget?.colors ?? page?.colors ?? global?.colors ?? {},
      ),
      align: mapToAlignment(
        widget?.align ?? page?.align ?? global?.align,
      ),
      fontSize: widget?.fontSize ?? page?.fontSize ?? global?.fontSize,
    );
  }

  SwitchGroupItem mapToButtonGroupItem(SwitchGroupItemDto item) {
    return SwitchGroupItem(
      id: item.id,
      name: item.name,
      value: item.value,
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
