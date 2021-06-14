part of failures;

@freezed
abstract class RemoveTokenFailure extends Failure with _$RemoveTokenFailure {
  const factory RemoveTokenFailure.unexpected() = _UnexpectedRemoveToken;
  const factory RemoveTokenFailure.connection() = _ConnectionRemoveToken;
  const factory RemoveTokenFailure.invalidToken() = _InvalidTokenRemoveToken;
  const factory RemoveTokenFailure.server() = _ServerRemoveToken;
  const factory RemoveTokenFailure.general(String message) =
      _GeneralRemoveToken;
}
