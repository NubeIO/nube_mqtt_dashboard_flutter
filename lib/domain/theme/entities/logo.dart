part of entities;

@freezed
abstract class Logo with _$Logo {
  const factory Logo({
    @required LogoItem dark,
    @required LogoItem light,
    @required double size,
    @required bool showIcon,
  }) = _Logo;
  factory Logo.empty() => Logo(
      dark: LogoItem.empty(),
      light: LogoItem.empty(),
      size: 40,
      showIcon: true);
}

@freezed
abstract class LogoItem with _$LogoItem {
  const factory LogoItem({
    @required String smallUrl,
    @required String largeUrl,
  }) = _LogoItem;

  factory LogoItem.empty() => const LogoItem(smallUrl: "", largeUrl: "");
}
