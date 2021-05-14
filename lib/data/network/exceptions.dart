import 'network_failure_cases.dart';

class NetworkException implements Exception {
  NetworkFailureCase get asFailure => const NetworkFailureCase.unexpected();
}

class AuthException implements NetworkException {
  @override
  NetworkFailureCase get asFailure => const NetworkFailureCase.auth();
}

class ConnectionException implements NetworkException {
  @override
  NetworkFailureCase get asFailure => const NetworkFailureCase.connection();
}

class RefreshException implements NetworkException {
  @override
  NetworkFailureCase get asFailure => const NetworkFailureCase.unexpected();
}

class ServerException implements NetworkException {
  @override
  NetworkFailureCase get asFailure => const NetworkFailureCase.server();
}

class UnexpectedException implements NetworkException {
  @override
  NetworkFailureCase get asFailure => const NetworkFailureCase.unexpected();
}

class GeneralException implements NetworkException {
  final String message;

  GeneralException(this.message);

  @override
  NetworkFailureCase get asFailure => NetworkFailureCase.general(message);
}

class NoHostException implements NetworkException {
  @override
  NetworkFailureCase get asFailure => const NetworkFailureCase.noHost();
}
