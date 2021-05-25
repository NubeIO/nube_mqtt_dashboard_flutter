part of entities;

abstract class EditableWidget {}

abstract class NonEditableWidget {}

@freezed
abstract class WidgetEntity with _$WidgetEntity {
  @Implements(NonEditableWidget)
  const factory WidgetEntity.gaugeWidget({
    @required String id,
    @required FlexibleTopic topic,
    @required String name,
    @required GaugeConfig config,
    @required GlobalConfig globalConfig,
  }) = _GaugeWidget;
  @Implements(EditableWidget)
  const factory WidgetEntity.sliderWidget({
    @required String id,
    @required FlexibleTopic topic,
    @required String name,
    @required SliderConfig config,
    @required GlobalConfig globalConfig,
  }) = _SliderWidget;
  @Implements(EditableWidget)
  const factory WidgetEntity.switchWidget({
    @required String id,
    @required FlexibleTopic topic,
    @required String name,
    @required SwitchConfig config,
    @required GlobalConfig globalConfig,
  }) = _SwitchWidget;
  @Implements(NonEditableWidget)
  const factory WidgetEntity.valueWidget({
    @required String id,
    @required FlexibleTopic topic,
    @required String name,
    @required ValueConfig config,
    @required GlobalConfig globalConfig,
  }) = _ValueWidget;
  @Implements(EditableWidget)
  const factory WidgetEntity.switchGroupWidget({
    @required String id,
    @required FlexibleTopic topic,
    @required String name,
    @required SwitchGroupConfig config,
    @required GlobalConfig globalConfig,
  }) = _SwitchGroupWidget;
  const factory WidgetEntity.mapWidget({
    @required String id,
    @required FlexibleTopic topic,
    @required String name,
    @required MapConfig config,
    @required GlobalConfig globalConfig,
  }) = _MapWidget;
  const factory WidgetEntity.failure({
    @required String id,
    @required FlexibleTopic topic,
    @required String name,
    @required LayoutParseFailure failure,
    @required GlobalConfig globalConfig,
  }) = _FailureWidget;
}

@freezed
abstract class GlobalConfig with _$GlobalConfig {
  const factory GlobalConfig({
    @required BackgroundConfig background,
    @required TitleConfig title,
    GridSize gridSize,
    double initial,
  }) = _GlobalConfig;

  factory GlobalConfig.empty({
    double initial,
  }) {
    return GlobalConfig(
      background: BackgroundConfig.empty(),
      title: TitleConfig.empty(),
      initial: initial,
    );
  }
}

@freezed
abstract class FlexibleTopic with _$FlexibleTopic {
  const factory FlexibleTopic({
    @required String read,
    @required String write,
  }) = _FlexibleTopic;

  factory FlexibleTopic.plain(String topic) =>
      FlexibleTopic(read: topic, write: topic);
}

@freezed
abstract class BackgroundConfig with _$BackgroundConfig {
  const factory BackgroundConfig({
    Color color,
    KtMap<double, Color> colors,
  }) = _BackgroundConfig;

  factory BackgroundConfig.empty() {
    return BackgroundConfig(colors: emptyMap());
  }
}

@freezed
abstract class TitleConfig with _$TitleConfig {
  const factory TitleConfig({
    double fontSize,
    Color color,
    @required KtMap<double, Color> colors,
    @required Alignment align,
  }) = _TitleConfig;

  factory TitleConfig.empty() => TitleConfig(
        align: const Alignment.left(),
        colors: emptyMap(),
      );
}

@freezed
abstract class GridSize with _$GridSize {
  const factory GridSize({
    @required int rowSpan,
    @required int columnSpan,
  }) = _GridSize;
}

@freezed
abstract class Alignment with _$Alignment {
  const factory Alignment.center() = _AlignCenter;
  const factory Alignment.left() = _AlignLeft;
  const factory Alignment.right() = _AlignRight;
}

extension SliderWidgetExt on _SliderWidget {
  WidgetData get defaultValue => WidgetData(value: config.defaultValue);
}

extension SwitchWidgetExt on _SwitchWidget {
  WidgetData get defaultValue => WidgetData(value: config.defaultValue ? 1 : 0);
}

extension SwitchGroupWidgetExt on _SwitchGroupWidget {
  WidgetData get defaultValue => WidgetData(value: config.defaultValue);
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
    @required double step,
    @required double defaultValue,
  }) = SliderConfig;

  const factory WidgetConfig.switchWidget({
    @required bool defaultValue,
  }) = SwitchConfig;

  const factory WidgetConfig.valueWidget({
    @required String unit,
    @required Alignment align,
    double fontSize,
  }) = ValueConfig;

  const factory WidgetConfig.buttonSwitchWidget({
    @required KtList<SwitchGroupItem> items,
    @required double defaultValue,
  }) = SwitchGroupConfig;

  const factory WidgetConfig.mapWidget({
    @required KtMap<double, String> maps,
    @required KtMap<double, Color> colors,
    @required Alignment align,
    double fontSize,
  }) = MapConfig;

  const factory WidgetConfig.emptyConfig() = EmptyConfig;
}

@freezed
abstract class SwitchGroupItem with _$SwitchGroupItem {
  const factory SwitchGroupItem({
    @required String id,
    @required String name,
    @required double value,
  }) = _SwitchGroupItem;
}
