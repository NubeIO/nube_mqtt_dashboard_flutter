import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_dto.freezed.dart';
part 'widget_dto.g.dart';

@freezed
abstract class WidgetDataDto with _$WidgetDataDto {
  const factory WidgetDataDto({
    @required dynamic value,
  }) = _WidgetDataDto;

  factory WidgetDataDto.fromJson(Map<String, dynamic> json) =>
      _$WidgetDataDtoFromJson(json);
}
