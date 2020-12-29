// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'layout.freezed.dart';
part 'layout.g.dart';

@freezed
abstract class Layout with _$Layout {
  const factory Layout({
    @required List<Page> pages,
  }) = _Layout;

  factory Layout.fromJson(Map<String, dynamic> json) => _$LayoutFromJson(json);
}

@freezed
abstract class Page with _$Page {
  const factory Page({
    @required String id,
    @required String name,
    @required List<Widget> widgets,
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

  factory Widget.fromJson(Map<String, dynamic> json) => _$WidgetFromJson(json);
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
    @JsonKey(name: 'default', defaultValue: 0) double defaultValue,
  }) = SliderConfigDto;

  const factory WidgetConfig.switchConfig({
    @JsonKey(name: 'default', defaultValue: false) bool defaultValue,
  }) = SwitchConfigDto;

  const factory WidgetConfig.valueConfig({
    @JsonKey(defaultValue: "") String unit,
  }) = ValueConfigDto;

  const factory WidgetConfig.emptyConfig() = EmptyConfigDto;

  factory WidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigFromJson(json);
}
