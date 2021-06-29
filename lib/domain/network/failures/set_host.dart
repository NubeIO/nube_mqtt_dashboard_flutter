part of failures;

@freezed
abstract class SetHostFailure extends Failure with _$SetHostFailure {
  const factory SetHostFailure.unexpected() = _UnexpectedGetUser;
  const factory SetHostFailure.connection() = _ConnectionSetHost;
  const factory SetHostFailure.server() = _ServerSetHost;
  const factory SetHostFailure.general(String message) = _GeneralSetHost;
}
