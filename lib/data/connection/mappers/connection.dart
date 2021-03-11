import 'package:connectivity/connectivity.dart';

import '../../../domain/connection/entities.dart';

class ConnectionMapper {
  ConnectionState mapToState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionState.WIFI;
      case ConnectivityResult.mobile:
        return ConnectionState.MOBILE;
      case ConnectivityResult.none:
        return ConnectionState.NONE;
    }
    return ConnectionState.NONE;
  }
}
