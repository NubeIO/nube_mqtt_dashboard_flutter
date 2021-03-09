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
                  relativePath: "/",
                  parentConfig: listOf(layout.widgetConfig),
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
    Page element, {
    @required KtList<GlobalWidgetConfigDto> parentConfig,
    @required String relativePath,
  }) {
    final config = parentConfig.plusElement(element.widgetConfig);
    return PageEntity(
      id: element.id,
      relativePath: "$relativePath${element.id}/",
      name: element.name,
      config: mapToPageConfig(element.config),
      widgets: element.widgets
          .map(
            (widget) => mapToWidget(
              widget,
              config: config,
            ),
          )
          .toImmutableList(),
      pages: element.pages
          .map((page) => mapToPage(
                page,
                relativePath: "$relativePath${element.id}/",
                parentConfig: config.plusElement(page.widgetConfig),
              ))
          .toImmutableList(),
    );
  }

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
    KtList<GlobalWidgetConfigDto> config,
  }) =>
      widget.map(
        GAUGE: (widget) {
          return WidgetEntity.gaugeWidget(
            id: widget.id,
            topic: mapToFlexibleTopic(widget.topic),
            name: widget.name,
            config: mapToGaugeConfig(config
                .mapNotNull((it) => it?.widget?.gaugeConfig)
                .plusElement(widget.config)),
            globalConfig: mapToGlobalConfig(
              widget.config,
              parentConfig: config,
            ),
          );
        },
        SWITCH: (widget) => WidgetEntity.switchWidget(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          config: mapToSwitchConfig(config
              .mapNotNull((it) => it?.widget?.switchConfig)
              .plusElement(widget.config)),
          globalConfig: mapToGlobalConfig(
            widget.config,
            parentConfig: config,
          ),
        ),
        SLIDER: (widget) => WidgetEntity.sliderWidget(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          config: mapToSliderConfig(config
              .mapNotNull((it) => it?.widget?.sliderConfig)
              .plusElement(widget.config)),
          globalConfig: mapToGlobalConfig(
            widget.config,
            parentConfig: config,
          ),
        ),
        VALUE: (widget) => WidgetEntity.valueWidget(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          config: mapToValueConfig(config
              .mapNotNull((it) => it?.widget?.valueConfig)
              .plusElement(widget.config)),
          globalConfig: mapToGlobalConfig(
            widget.config,
            parentConfig: config,
          ),
        ),
        SWITCH_GROUP: (widget) {
          return WidgetEntity.switchGroupWidget(
            id: widget.id,
            topic: mapToFlexibleTopic(widget.topic),
            name: widget.name,
            config: mapToSwitchGroupConfig(config
                .mapNotNull((it) => it?.widget?.switchGroupConfig)
                .plusElement(widget.config)),
            globalConfig: mapToGlobalConfig(
              widget.config,
              parentConfig: config,
            ),
          );
        },
        MAP: (widget) {
          return WidgetEntity.mapWidget(
            id: widget.id,
            topic: mapToFlexibleTopic(widget.topic),
            name: widget.name,
            config: mapToMapConfig(config
                .mapNotNull((it) => it?.widget?.mapConfig)
                .plusElement(widget.config)),
            globalConfig: mapToGlobalConfig(
              widget.config,
              parentConfig: config,
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
            parentConfig: config,
          ),
        ),
        unknownWidget: (value) => WidgetEntity.failure(
          id: widget.id,
          topic: mapToFlexibleTopic(widget.topic),
          name: widget.name,
          failure: const LayoutParseFailure.unknown(),
          globalConfig: mapToGlobalConfig(
            const WidgetConfigDto.emptyConfig(),
            parentConfig: config,
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
    @required KtList<GlobalWidgetConfigDto> parentConfig,
  }) {
    return GlobalConfig(
      background: mapToBackground(parentConfig
          .mapNotNull((it) => it?.background)
          .plusElement(config?.background)),
      title: mapToTitle(parentConfig
          .mapNotNull((it) => it?.title)
          .plusElement(config?.title)),
      initial: mapToInitial(parentConfig
          .mapNotNull((it) => it?.initial)
          .plusElement(config?.initial)),
    );
  }

  double mapToInitial(
    KtList<double> config,
  ) {
    return config.lastOrNull((it) => it != null);
  }

  BackgroundConfig mapToBackground(
    KtList<BackgroundConfigDto> config,
  ) {
    final background = config.lastOrNull((it) => it != null);
    if (background == null) return BackgroundConfig.empty();
    final hexColor = config.mapAndNonNull((it) => it.color);
    return BackgroundConfig(
      color: hexColor != null ? HexColor.parseColor(hexColor) : null,
      colors: mapToColorsKeys(config.mapAndNonNull((it) => it.colors) ?? {}),
    );
  }

  TitleConfig mapToTitle(
    KtList<TitleConfigDto> config,
  ) {
    final hexColor = config.mapAndNonNull((it) => it.color);
    return TitleConfig(
      fontSize: config.mapAndNonNull((it) => it.fontSize),
      align: mapToAlignment(
        config.mapAndNonNull((it) => it.align),
      ),
      color: hexColor != null ? HexColor.parseColor(hexColor) : null,
      colors: mapToColorsKeys(config.mapAndNonNull((it) => it.colors) ?? {}),
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
    KtList<GaugeConfigDto> config,
  ) {
    return GaugeConfig(
      min: config.mapAndNonNull((it) => it.min) ?? 0,
      max: config.mapAndNonNull((it) => it.max) ?? 100,
    );
  }

  SwitchConfig mapToSwitchConfig(
    KtList<SwitchConfigDto> config,
  ) {
    return SwitchConfig(
      defaultValue: config.mapAndNonNull((it) => it.defaultValue) ?? false,
    );
  }

  SliderConfig mapToSliderConfig(
    KtList<SliderConfigDto> config,
  ) {
    return SliderConfig(
      min: config.mapAndNonNull((it) => it.min) ?? 0,
      max: config.mapAndNonNull((it) => it.max) ?? 100,
      step: config.mapAndNonNull((it) => it.step) ?? 1,
      defaultValue: config.mapAndNonNull((it) => it.defaultValue) ?? 0,
    );
  }

  ValueConfig mapToValueConfig(
    KtList<ValueConfigDto> config,
  ) {
    return ValueConfig(
      unit: config.mapAndNonNull((it) => it.unit) ?? "",
      align: mapToAlignment(
        config.mapAndNonNull((it) => it.align),
      ),
      fontSize: config.mapAndNonNull((it) => it.fontSize),
    );
  }

  SwitchGroupConfig mapToSwitchGroupConfig(
    KtList<SwitchGroupConfigDto> config,
  ) {
    return SwitchGroupConfig(
      items: (config.mapAndNonNull((it) => it.items) ?? [])
          .map(mapToButtonGroupItem)
          .toImmutableList(),
      defaultValue: config.mapAndNonNull((it) => it.defaultValue) ?? 0,
    );
  }

  MapConfig mapToMapConfig(
    KtList<MapConfigDto> config,
  ) {
    return MapConfig(
      maps: mapToDoubleKeys(
        config.mapAndNonNull((it) => it.maps) ?? {},
      ),
      colors: mapToColorsKeys(
        config.mapAndNonNull((it) => it.colors) ?? {},
      ),
      align: mapToAlignment(
        config.mapAndNonNull((it) => it.align),
      ),
      fontSize: config.mapAndNonNull((it) => it.fontSize),
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

extension ComparableIterableExtension<T> on KtList<T> {
  R mapAndNonNull<R>(R Function(T) transform) {
    final mapped =
        mapNotNull((it) => it).mapNotNullTo(mutableListOf<R>(), transform);
    return mapped.lastOrNull((it) => it != null);
  }
}
