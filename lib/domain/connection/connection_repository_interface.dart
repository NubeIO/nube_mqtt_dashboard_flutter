import 'entities.dart';

export 'entities.dart';

abstract class IConnectionRepository {
  Stream<ConnectionState> get layoutStream;
}
