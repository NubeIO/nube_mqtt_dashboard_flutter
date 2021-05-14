part of failures;

@freezed
abstract class TokenStreamFailure with _$TokenStreamFailure {
  const factory TokenStreamFailure.unexpected() = _UnexpectedTokenStream;
}
