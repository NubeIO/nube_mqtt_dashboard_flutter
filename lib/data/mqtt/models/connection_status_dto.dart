import 'package:freezed_annotation/freezed_annotation.dart';

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
        timestamp: DateTime.now().toIso8601String(),
      );

  factory ConnectionStatusDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectionStatusDtoFromJson(json);
}
