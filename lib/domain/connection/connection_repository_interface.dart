import '../core/interfaces/repository.dart';
import 'entities.dart';

export 'entities.dart';

abstract class IConnectionRepository implements IRepository {
  Stream<ConnectionState> get layoutStream;
}
