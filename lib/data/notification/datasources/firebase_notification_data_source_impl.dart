import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/notifications/notification_data_source_interface.dart';

@Singleton(as: INotificationDataSource)
class NotificationDataSource extends INotificationDataSource {
  NotificationDataSource() {
    Firebase.initializeApp();
  }

  @override
  Future<String> getToken() async {
    return FirebaseMessaging().getToken();
  }

  @override
  Stream<String> get tokenStream => FirebaseMessaging().onTokenRefresh;
}
