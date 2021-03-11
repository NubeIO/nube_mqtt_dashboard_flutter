part of entities;

enum ConnectionState { WIFI, MOBILE, NONE }

extension ConnectionStateEx on ConnectionState {
  bool get isConnected => this != ConnectionState.NONE;
}
