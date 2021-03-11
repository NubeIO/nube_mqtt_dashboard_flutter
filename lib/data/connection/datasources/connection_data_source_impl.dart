import 'package:connectivity/connectivity.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/connection/connection_data_source_interface.dart';
import '../../../utils/logger/log.dart';
import '../mappers/connection.dart';

const _TAG = "ConnectionDataSource";

@LazySingleton(as: IConnectionDataSource)
class ConnectionDataSourceImpl extends IConnectionDataSource {
  final BehaviorSubject<ConnectionState> _connectionState =
      BehaviorSubject.seeded(ConnectionState.NONE)
        ..listen((event) {
          Log.d("Connection Status $event", tag: _TAG);
        });

  final _connectionMapper = ConnectionMapper();

  ConnectionDataSourceImpl() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      Log.i("Connection result $result", tag: _TAG);
      _connectionState.add(_connectionMapper.mapToState(result));
    });
  }

  @override
  Stream<ConnectionState> get layoutStream => _connectionState.stream;
}
