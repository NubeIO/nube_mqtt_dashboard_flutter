part of failures;

@freezed
abstract class ConnectFailure extends Failure with _$ConnectFailure {
  const factory ConnectFailure.unexpected() = _UnexpectedConnect;
}
