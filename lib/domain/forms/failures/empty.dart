part of failures;

@freezed
abstract class EmptyFailure extends Failure with _$EmptyFailure {
  const factory EmptyFailure.empty() = _Empty;
}
