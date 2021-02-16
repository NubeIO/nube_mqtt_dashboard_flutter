import 'package:nube_mqtt_dashboard/data/mqtt/models/topic_message_dto.dart';
import 'package:nube_mqtt_dashboard/domain/mqtt/entities.dart';

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
