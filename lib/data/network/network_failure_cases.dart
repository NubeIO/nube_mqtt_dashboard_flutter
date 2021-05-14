import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_failure_cases.freezed.dart';

@freezed
abstract class NetworkFailureCase with _$NetworkFailureCase {
  const factory NetworkFailureCase.auth() = _AuthException;
  const factory NetworkFailureCase.noHost() = _HostException;
  const factory NetworkFailureCase.connection() = _ConnectionException;
  const factory NetworkFailureCase.server() = _ServerException;
  const factory NetworkFailureCase.unexpected() = _UnexpectedException;
  const factory NetworkFailureCase.general(String message) = _GeneralException;
}
