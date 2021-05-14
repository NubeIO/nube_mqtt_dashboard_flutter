import '../core/interfaces/datasource.dart';

abstract class INotificationDataSource implements IDataSource {
  Future<String> getToken();

  Stream<String> get tokenStream;
}
