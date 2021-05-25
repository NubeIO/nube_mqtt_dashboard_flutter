import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/notifications/notification_data_source_interface.dart';
import '../../../utils/logger/log.dart';
import '../mapper/notifications.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  Log.d('onBackgroundMessage $message', tag: _TAG);
}

const _TAG = "NotificationDataSource";

@Singleton(as: INotificationDataSource)
class NotificationDataSource extends INotificationDataSource {
  final BehaviorSubject<NotificationData> _notificationPublisher =
      BehaviorSubject()
        ..listen((event) {
          Log.i("NotificationDataSource $event", tag: _TAG);
        });

  final notificationMapper = NotificationMapper();

  NotificationDataSource() {
    Firebase.initializeApp();
    FirebaseMessaging().configure(
      onMessage: _onMessage,
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: _onLaunch,
      onResume: _onResume,
    );
  }

  Future _onResume(Map<String, dynamic> message) async {
    Log.d("onResume $message", tag: _TAG);
  }

  Future _onLaunch(Map<String, dynamic> message) async {
    Log.d("onLaunch $message", tag: _TAG);
  }

  Future _onMessage(Map<String, dynamic> message) async {
    Log.d("OnMessage $message", tag: _TAG);
    final data = message["data"];
    if (data != null) {
      _notificationPublisher.add(notificationMapper.mapToNotification(data));
    }
  }

  @override
  Future<String> getToken() async {
    return FirebaseMessaging().getToken();
  }

  @override
  Stream<String> get tokenStream => FirebaseMessaging().onTokenRefresh;

  @override
  Stream<NotificationData> get notificationStream =>
      _notificationPublisher.stream;
}
