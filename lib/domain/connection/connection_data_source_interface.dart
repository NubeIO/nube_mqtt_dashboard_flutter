import 'entities.dart';

export 'entities.dart';

abstract class IConnectionDataSource {
  Stream<ConnectionState> get layoutStream;
}
