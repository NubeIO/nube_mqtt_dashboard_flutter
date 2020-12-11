part of failures;

@freezed
abstract class LayoutFailure extends Failure with _$LayoutFailure {
  const factory LayoutFailure.invalidLayout() = _InvalidLayout;
  const factory LayoutFailure.unexpected() = _Unexpected;
}
