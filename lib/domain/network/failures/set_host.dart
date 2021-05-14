part of failures;

@freezed
abstract class SetHostFailure extends Failure with _$SetHostFailure {
  const factory SetHostFailure.unexpected() = _UnexpectedSetHost;
}
