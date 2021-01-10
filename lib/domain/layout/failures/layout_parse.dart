part of failures;

@freezed
abstract class LayoutParseFailure extends Failure with _$LayoutParseFailure {
  const factory LayoutParseFailure.unknown() = _UnknownWidgetParse;
  const factory LayoutParseFailure.parse() = _InvalidParseParse;
}
