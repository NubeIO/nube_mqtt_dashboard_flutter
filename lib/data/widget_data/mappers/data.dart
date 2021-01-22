import '../../../domain/widget_data/entities.dart';
import '../models/widget_dto.dart';

class DataMapper {
  WidgetData mapToWidgetData(WidgetDataDto widgetDataDto) {
    return WidgetData(value: mapValue(widgetDataDto.value));
  }

  WidgetDataDto mapToWidgetDataDto(WidgetData value) {
    return WidgetDataDto(value: value.value.toString());
  }

  double mapValue(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is num) {
      return value.toDouble();
    }
    return 0;
  }
}
