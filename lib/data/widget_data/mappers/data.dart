import '../../../domain/widget_data/entities.dart';
import '../models/widget_dto.dart';

class DataMapper {
  WidgetData mapToWidgetData(WidgetDataDto widgetDataDto) {
    return WidgetData(value: widgetDataDto.value);
  }
}
