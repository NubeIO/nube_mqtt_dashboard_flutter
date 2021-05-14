part of failures;

@freezed
abstract class GetTokenFailure with _$GetTokenFailure {
  const factory GetTokenFailure.unexpected() = _UnexpectedGetToken;
  const factory GetTokenFailure.empty() = _EmptyGetToken;
}
