part of entities;

@freezed
abstract class LayoutBuilder with _$LayoutBuilder {
  const factory LayoutBuilder({
    @required KtList<PageEntity> pages,
  }) = _LayoutBuilder;

  factory LayoutBuilder.empty() {
    return const LayoutBuilder(pages: KtList.empty());
  }
}
