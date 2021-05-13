import '../../../domain/mqtt/entities.dart';
import '../models/topic_message_dto.dart';

class TopicMessageMapper {
  TopicMessage mapToTopicMesage(TopicMessageDto topicMessageDto) {
    return TopicMessage(
      topic: topicMessageDto.topic,
      message: topicMessageDto.message,
    );
  }

  TopicMessageDto mapFromTopicMessage(TopicMessage message) {
    return TopicMessageDto(
      topic: message.topic,
      message: message.message,
    );
  }
}
