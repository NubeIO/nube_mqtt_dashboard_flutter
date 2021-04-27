import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nube_mqtt_dashboard/utils/date_utils.dart';

part 'connection_status_dto.freezed.dart';
part 'connection_status_dto.g.dart';

@freezed
abstract class ConnectionStatusDto with _$ConnectionStatusDto {
  const factory ConnectionStatusDto({
    @required List<String> subscriptions,
    @required String timestamp,
  }) = _ConnectionStatusDto;

  factory ConnectionStatusDto.simple(List<String> subscriptions) =>
      ConnectionStatusDto(
        subscriptions: subscriptions,
        timestamp: DateUtils.getISOTimeString(),
      );

  factory ConnectionStatusDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectionStatusDtoFromJson(json);
}
