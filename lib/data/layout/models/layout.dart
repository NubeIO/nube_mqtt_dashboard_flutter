// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nube_mqtt_dashboard/domain/layout/exceptions/layout.dart';
import 'package:nube_mqtt_dashboard/utils/logger/log.dart';

part 'layout.freezed.dart';
part 'layout.g.dart';

@freezed
abstract class Layout with _$Layout {
  const factory Layout({
    @required List<Page> pages,
    LayoutConfig config,
    LogoConfig logo,
    @JsonKey(name: 'widget_config') GlobalWidgetConfigDto widgetConfig,
  }) = _Layout;

  factory Layout.fromJson(Map<String, dynamic> json) => _$LayoutFromJson(json);
}

@freezed
abstract class Page with _$Page {
  const factory Page({
    @required String id,
    @required String name,
    PageConfig config,
    @JsonKey(name: 'widget_config') GlobalWidgetConfigDto widgetConfig,
    @WidgetResponseConverter() @required List<Widget> widgets,
  }) = _Page;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}

@Freezed(unionKey: "type")
abstract class Widget with _$Widget {
  const factory Widget.GAUGE({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    GaugeConfigDto config,
  }) = _GaugeWidget;

  const factory Widget.SWITCH({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    SwitchConfigDto config,
  }) = _SwitchWidget;

  const factory Widget.SLIDER({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    SliderConfigDto config,
  }) = _SliderWidget;

  const factory Widget.VALUE({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    ValueConfigDto config,
  }) = _ValueWidget;

  const factory Widget.SWITCH_GROUP({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    SwitchGroupConfigDto config,
  }) = _SwitchGroupWidget;

  const factory Widget.MAP({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    MapConfigDto config,
  }) = _MapWidget;

  const factory Widget.unknownWidget({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    GlobalWidgetConfigDto config,
  }) = _UnknownFailureWidget;

  const factory Widget.invalidParse({
    @required String id,
    @FlexibleTopicConverter() @required FlexibleTopicDto topic,
    @required String name,
    GlobalWidgetConfigDto config,
  }) = _InvalidParseWidget;

  factory Widget.fromJson(Map<String, dynamic> json) => _$WidgetFromJson(json);
}

@freezed
abstract class FlexibleTopicDto with _$FlexibleTopicDto {
  const factory FlexibleTopicDto({
    @required String read,
    @required String write,
  }) = _FlexibleTopicDto;

  factory FlexibleTopicDto.fromJson(Map<String, dynamic> json) =>
      _$FlexibleTopicDtoFromJson(json);

  factory FlexibleTopicDto.plain(String topic) =>
      FlexibleTopicDto(read: topic, write: topic);
}

@freezed
abstract class BackgroundConfigDto with _$BackgroundConfigDto {
  const factory BackgroundConfigDto({
    String color,
    @JsonKey(defaultValue: {}) Map<String, String> colors,
  }) = _BackgroundConfigDto;

  factory BackgroundConfigDto.fromJson(Map<String, dynamic> json) =>
      _$BackgroundConfigDtoFromJson(json);
}

@freezed
abstract class TitleConfigDto with _$TitleConfigDto {
  const factory TitleConfigDto({
    @JsonKey(name: 'font_size') double fontSize,
    @JsonKey(unknownEnumValue: AlignmentType.LEFT) AlignmentType align,
    String color,
  }) = _TitleConfigDto;

  factory TitleConfigDto.fromJson(Map<String, dynamic> json) =>
      _$TitleConfigDtoFromJson(json);
}

enum AlignmentType {
  @JsonValue("center")
  CENTER,
  @JsonValue("left")
  LEFT,
  @JsonValue("right")
  RIGHT
}

@freezed
abstract class GlobalWidgetConfigDto with _$GlobalWidgetConfigDto {
  const factory GlobalWidgetConfigDto({
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = _GlobalWidgetConfigDto;

  factory GlobalWidgetConfigDto.empty() => const GlobalWidgetConfigDto();

  factory GlobalWidgetConfigDto.fromJson(Map<String, dynamic> json) =>
      _$GlobalWidgetConfigDtoFromJson(json);
}

class FlexibleTopicConverter
    implements JsonConverter<FlexibleTopicDto, dynamic> {
  const FlexibleTopicConverter();

  @override
  FlexibleTopicDto fromJson(dynamic topic) {
    if (topic is String) {
      return FlexibleTopicDto(read: topic, write: topic);
    } else if (topic is Map<String, dynamic>) {
      try {
        final read = topic["read"] as String;
        final write = topic["write"] as String;
        return FlexibleTopicDto(
          read: read,
          write: write,
        );
      } catch (e) {
        throw InvalidTopicException();
      }
    }
    throw InvalidTopicException();
  }

  @override
  Map<String, dynamic> toJson(FlexibleTopicDto data) {
    return data.toJson();
  }
}

class WidgetResponseConverter
    implements JsonConverter<Widget, Map<String, dynamic>> {
  const WidgetResponseConverter();

  @override
  Widget fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final id = json["id"] as String;
    final topic = json["topic"] as dynamic;
    final name = json["name"] as String;
    try {
      // type data was already set (e.g. because we serialized it ourselves)
      final type = json['type'] as String;
      if (type != null && isValidType(type)) {
        return Widget.fromJson(json);
      } else {
        Log.e("Unknown Widget type: $type");
        return Widget.unknownWidget(
          id: id,
          topic: const FlexibleTopicConverter().fromJson(topic),
          name: name,
        );
      }
    } catch (e) {
      Log.e("Error Parsing Widget", ex: e);
      return Widget.invalidParse(
        id: id ?? "unknown_id",
        topic: e is InvalidTopicException
            ? FlexibleTopicDto.plain("")
            : const FlexibleTopicConverter().fromJson(topic),
        name: name ?? "",
      );
    }
  }

  @override
  Map<String, dynamic> toJson(Widget data) => data.toJson();
}

bool isValidType(String type) {
  return getType(type) != WidgetType.UNKNOWN;
}

enum WidgetType { GAUGE, SWITCH, SLIDER, VALUE, SWITCH_GROUP, MAP, UNKNOWN }

WidgetType getType(String type) {
  switch (type) {
    case 'GAUGE':
      return WidgetType.GAUGE;
    case 'SWITCH':
      return WidgetType.SWITCH;
    case 'SLIDER':
      return WidgetType.SLIDER;
    case 'VALUE':
      return WidgetType.VALUE;
    case 'SWITCH_GROUP':
      return WidgetType.SWITCH_GROUP;
    case 'MAP':
      return WidgetType.MAP;
    default:
      return WidgetType.UNKNOWN;
  }
}

@freezed
abstract class PageConfig with _$PageConfig {
  const factory PageConfig({
    @JsonKey(defaultValue: false) bool protected,
    @JsonKey(name: 'timeout') PageTimeoutEntity pageTimeout,
  }) = _PageConfig;

  factory PageConfig.fromJson(Map<String, dynamic> json) =>
      _$PageConfigFromJson(json);
}

@freezed
abstract class LayoutConfig with _$LayoutConfig {
  const factory LayoutConfig({
    @JsonKey(name: "show_loading", defaultValue: false) bool showLoading,
    @JsonKey(name: "persistent", defaultValue: true) bool persistData,
  }) = _LayoutConfig;

  factory LayoutConfig.fromJson(Map<String, dynamic> json) =>
      _$LayoutConfigFromJson(json);
}

@freezed
abstract class LogoConfig with _$LogoConfig {
  const factory LogoConfig({
    LogoItemDto light,
    LogoItemDto dark,
    @JsonKey(defaultValue: 40) double size,
    @JsonKey(name: "show_icon", defaultValue: true) bool showIcon,
  }) = _LogoConfig;

  factory LogoConfig.fromJson(Map<String, dynamic> json) =>
      _$LogoConfigFromJson(json);
}

@freezed
abstract class LogoItemDto with _$LogoItemDto {
  const factory LogoItemDto({
    @JsonKey(defaultValue: "") String small,
    @JsonKey(defaultValue: "") String large,
  }) = _LogoItemDto;

  factory LogoItemDto.fromJson(Map<String, dynamic> json) =>
      _$LogoItemDtoFromJson(json);
}

@freezed
abstract class PageTimeoutEntity with _$PageTimeoutEntity {
  const factory PageTimeoutEntity({
    @required @JsonKey(name: "fallback") String fallbackId,
    @JsonKey(defaultValue: 60000) int duration,
  }) = _PageTimeoutEntity;

  factory PageTimeoutEntity.fromJson(Map<String, dynamic> json) =>
      _$PageTimeoutEntityFromJson(json);
}

@freezed
abstract class WidgetConfigDto with _$WidgetConfigDto {
  const factory WidgetConfigDto.gaugeConfig({
    @JsonKey(defaultValue: 0) int min,
    @JsonKey(defaultValue: 100) int max,
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = GaugeConfigDto;

  const factory WidgetConfigDto.sliderConfig({
    @JsonKey(defaultValue: 0) int min,
    @JsonKey(defaultValue: 100) int max,
    @JsonKey(defaultValue: 1) double step,
    @JsonKey(name: 'default', defaultValue: 0) double defaultValue,
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = SliderConfigDto;

  const factory WidgetConfigDto.switchConfig({
    @JsonKey(name: 'default', defaultValue: false) bool defaultValue,
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = SwitchConfigDto;

  const factory WidgetConfigDto.valueConfig({
    @JsonKey(defaultValue: "") String unit,
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = ValueConfigDto;

  const factory WidgetConfigDto.switchGroupConfig({
    @JsonKey(defaultValue: []) List<SwitchGroupItemDto> items,
    @JsonKey(name: 'default', defaultValue: 0) double defaultValue,
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = SwitchGroupConfigDto;

  const factory WidgetConfigDto.mapConfig({
    @JsonKey(defaultValue: {}) Map<String, String> maps,
    @JsonKey(defaultValue: {}) Map<String, String> colors,
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = MapConfigDto;

  const factory WidgetConfigDto.emptyConfig({
    BackgroundConfigDto background,
    TitleConfigDto title,
  }) = EmptyConfigDto;

  factory WidgetConfigDto.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigDtoFromJson(json);
}

@freezed
abstract class SwitchGroupItemDto with _$SwitchGroupItemDto {
  const factory SwitchGroupItemDto({
    @required String id,
    @required String name,
    @required double value,
  }) = _SwitchGroupItemDto;

  factory SwitchGroupItemDto.fromJson(Map<String, dynamic> json) =>
      _$SwitchGroupItemDtoFromJson(json);
}
