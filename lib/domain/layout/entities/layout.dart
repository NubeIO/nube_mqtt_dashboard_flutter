part of entities;

@freezed
abstract class LayoutEntity with _$LayoutEntity {
  const factory LayoutEntity({
    @required KtList<PageEntity> pages,
  }) = _LayoutEntity;

  factory LayoutEntity.empty() {
    return const LayoutEntity(pages: KtList.empty());
  }
}
