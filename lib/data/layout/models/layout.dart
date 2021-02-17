// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nube_mqtt_dashboard/utils/logger/log.dart';

part 'layout.freezed.dart';
part 'layout.g.dart';

@freezed
abstract class Layout with _$Layout {
  const factory Layout({
    @required List<Page> pages,
    LayoutConfig config,
    LogoConfig logo,
  }) = _Layout;

  factory Layout.fromJson(Map<String, dynamic> json) => _$LayoutFromJson(json);
}

@freezed
abstract class Page with _$Page {
  const factory Page({
    @required String id,
    @required String name,
    PageConfig config,
    @WidgetResponseConverter() @required List<Widget> widgets,
  }) = _Page;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}

@Freezed(unionKey: "type")
abstract class Widget with _$Widget {
  const factory Widget.GAUGE({
    @required String id,
    @required String topic,
    @required String name,
    GaugeConfigDto config,
  }) = _GaugeWidget;

  const factory Widget.SWITCH({
    @required String id,
    @required String topic,
    @required String name,
    SwitchConfigDto config,
  }) = _SwitchWidget;

  const factory Widget.SLIDER({
    @required String id,
    @required String topic,
    @required String name,
    SliderConfigDto config,
  }) = _SliderWidget;

  const factory Widget.VALUE({
    @required String id,
    @required String topic,
    @required String name,
    ValueConfigDto config,
  }) = _ValueWidget;

  const factory Widget.SWITCH_GROUP({
    @required String id,
    @required String topic,
    @required String name,
    SwitchGroupConfigDto config,
  }) = _SwitchGroupWidget;

  const factory Widget.MAP({
    @required String id,
    @required String topic,
    @required String name,
    MapConfigDto config,
  }) = _MapWidget;

  const factory Widget.unknownWidget({
    @required String id,
    @required String topic,
    @required String name,
  }) = _UnknownFailureWidget;

  const factory Widget.invalidParse({
    @required String id,
    @required String topic,
    @required String name,
  }) = _InvalidParseWidget;

  factory Widget.fromJson(Map<String, dynamic> json) => _$WidgetFromJson(json);
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
    final topic = json["topic"] as String;
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
          topic: topic,
          name: name,
        );
      }
    } catch (e) {
      Log.e("Error Parsing Widget", ex: e);
      return Widget.invalidParse(
        id: id ?? "unknown_id",
        topic: topic ?? "",
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
abstract class WidgetConfig with _$WidgetConfig {
  const factory WidgetConfig.gaugeConfig({
    @JsonKey(defaultValue: 0) int min,
    @JsonKey(defaultValue: 100) int max,
  }) = GaugeConfigDto;

  const factory WidgetConfig.sliderConfig({
    @JsonKey(defaultValue: 0) int min,
    @JsonKey(defaultValue: 100) int max,
    @JsonKey(defaultValue: 1) double step,
    @JsonKey(name: 'default', defaultValue: 0) double defaultValue,
  }) = SliderConfigDto;

  const factory WidgetConfig.switchConfig({
    @JsonKey(name: 'default', defaultValue: false) bool defaultValue,
  }) = SwitchConfigDto;

  const factory WidgetConfig.valueConfig({
    @JsonKey(defaultValue: "") String unit,
  }) = ValueConfigDto;

  const factory WidgetConfig.switchGroupConfig({
    @JsonKey(defaultValue: []) List<SwitchGroupItemDto> items,
    @JsonKey(name: 'default', defaultValue: 0) double defaultValue,
  }) = SwitchGroupConfigDto;

  const factory WidgetConfig.mapConfig({
    @JsonKey(defaultValue: {}) Map<String, String> maps,
    @JsonKey(defaultValue: {}) Map<String, String> colors,
  }) = MapConfigDto;

  const factory WidgetConfig.emptyConfig() = EmptyConfigDto;

  factory WidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigFromJson(json);
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
