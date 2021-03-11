import 'package:injectable/injectable.dart';

import '../../../domain/connection/connection_data_source_interface.dart';
import '../../../domain/connection/connection_repository_interface.dart';

@LazySingleton(as: IConnectionRepository)
class ConnectionRepositoryImpl extends IConnectionRepository {
  final IConnectionDataSource _connectionDataSource;

  ConnectionRepositoryImpl(this._connectionDataSource);

  @override
  Stream<ConnectionState> get layoutStream =>
      _connectionDataSource.layoutStream;
}
