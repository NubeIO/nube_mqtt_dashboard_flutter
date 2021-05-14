import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/notifications/notification_data_source_interface.dart';

@LazySingleton(as: INotificationDataSource)
class NotificationDataSource extends INotificationDataSource {
  NotificationDataSource();

  @override
  Future<String> getToken() {
    return FirebaseMessaging().getToken();
  }

  @override
  Stream<String> get tokenStream => FirebaseMessaging().onTokenRefresh;
}
