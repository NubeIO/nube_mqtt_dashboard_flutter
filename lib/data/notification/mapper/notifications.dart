import '../../../domain/notifications/entities.dart';

class NotificationMapper {
  NotificationData mapToNotification(dynamic data) {
    final type = data["type"];
    if (type is String) {
      switch (type) {
        case "USER_VERIFICATION":
          return const NotificationData.verification();
      }
    }
    return NotificationData.unknown(data: data);
  }
}
