import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_message_dto.freezed.dart';
part 'topic_message_dto.g.dart';

@freezed
abstract class TopicMessageDto with _$TopicMessageDto {
  const factory TopicMessageDto({
    @required String topic,
    @required String message,
  }) = _TopicMessageDto;

  factory TopicMessageDto.fromJson(Map<String, dynamic> json) =>
      _$TopicMessageDtoFromJson(json);
}
