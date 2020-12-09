import 'entities.dart';

abstract class ISessionDataSource {
  Future<SessionType> getSessionType();
}
