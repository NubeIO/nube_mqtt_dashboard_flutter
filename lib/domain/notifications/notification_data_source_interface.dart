import '../core/interfaces/datasource.dart';
import 'entities.dart';

export 'entities.dart';

abstract class INotificationDataSource implements IDataSource {
  Future<String> getToken();

  Stream<String> get tokenStream;

  Stream<NotificationData> get notificationStream;
}
