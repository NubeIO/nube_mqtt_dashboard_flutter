part of entities;

abstract class EditableWidget {}

abstract class NonEditableWidget {}

@freezed
abstract class WidgetEntity with _$WidgetEntity {
  @Implements(NonEditableWidget)
  const factory WidgetEntity.gaugeWidget({
    @required String id,
    @required String topic,
    @required String name,
    @required GaugeConfig config,
  }) = _GaugeWidget;
  @Implements(EditableWidget)
  const factory WidgetEntity.sliderWidget({
    @required String id,
    @required String topic,
    @required String name,
    @required SliderConfig config,
  }) = _SliderWidget;
  @Implements(EditableWidget)
  const factory WidgetEntity.switchWidget({
    @required String id,
    @required String topic,
    @required String name,
    @required SwitchConfig config,
  }) = _SwitchWidget;
  @Implements(NonEditableWidget)
  const factory WidgetEntity.valueWidget({
    @required String id,
    @required String topic,
    @required String name,
    @required ValueConfig config,
  }) = _ValueWidget;
}

extension SliderWidgetExt on _SliderWidget {
  WidgetData get defaultValue => WidgetData(value: config.defaultValue);
}

extension SwitchWidgetExt on _SwitchWidget {
  WidgetData get defaultValue => WidgetData(value: config.defaultValue ? 1 : 0);
}

@freezed
abstract class WidgetConfig with _$WidgetConfig {
  const factory WidgetConfig.gaugeConfig({
    @required int min,
    @required int max,
  }) = GaugeConfig;

  const factory WidgetConfig.sliderConfig({
    @required int min,
    @required int max,
    @required double defaultValue,
  }) = SliderConfig;

  const factory WidgetConfig.switchWidget({
    @required bool defaultValue,
  }) = SwitchConfig;

  const factory WidgetConfig.valueWidget({
    @required String unit,
  }) = ValueConfig;

  const factory WidgetConfig.emptyConfig() = EmptyConfig;
}
