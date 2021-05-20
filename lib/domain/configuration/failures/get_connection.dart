part of failures;

@freezed
abstract class GetConnectionFailure extends Failure
    with _$GetConnectionFailure {
  const factory GetConnectionFailure.unexpected() = _UnexpectedGetConnection;
  const factory GetConnectionFailure.connection() = _ConnectionGetConnection;
  const factory GetConnectionFailure.invalidToken() =
      _InvalidTokenGetConnection;
  const factory GetConnectionFailure.server() = _ServerGetConnection;
  const factory GetConnectionFailure.general(String message) =
      _GeneralGetConnection;
}
