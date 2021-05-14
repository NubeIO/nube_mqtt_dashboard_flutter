import '../core/interfaces/datasource.dart';
import 'entities.dart';

export 'entities.dart';

abstract class IConnectionDataSource implements IDataSource {
  Stream<ConnectionState> get layoutStream;
}
