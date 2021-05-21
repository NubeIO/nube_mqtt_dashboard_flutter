import 'package:freezed_annotation/freezed_annotation.dart';

part 'alerts.freezed.dart';
part 'alerts.g.dart';

@freezed
abstract class Alerts with _$Alerts {
  const factory Alerts({
    @JsonKey(name: 'alerts') List<AlertResponse> alerts,
  }) = _Alerts;

  factory Alerts.fromJson(Map<String, dynamic> json) => _$AlertsFromJson(json);
}

@freezed
abstract class AlertResponse with _$AlertResponse {
  const factory AlertResponse({
    @JsonKey(name: 'timestamp') @required int timestamp,
    @JsonKey(name: 'title') @required String title,
    @JsonKey(name: 'subtitle') @required String subtitle,
    @JsonKey(name: 'alert_type') @required String alertType,
    @JsonKey(name: 'priority', unknownEnumValue: PriorityResponse.LOW)
        PriorityResponse priority,
  }) = _AlertResponse;

  factory AlertResponse.fromJson(Map<String, dynamic> json) =>
      _$AlertResponseFromJson(json);
}

enum PriorityResponse {
  @JsonValue("high")
  HIGH,
  @JsonValue("normal")
  NORMAL,
  @JsonValue("low")
  LOW
}
