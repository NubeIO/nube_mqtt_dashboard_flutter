part of failures;

@freezed
abstract class SaveAndConnectFailure extends Failure
    with _$SaveAndConnectFailure {
  const factory SaveAndConnectFailure.unexpected() = _UnexpectedConnect;
}
