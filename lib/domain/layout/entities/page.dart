part of entities;

@freezed
abstract class PageEntity with _$PageEntity {
  const factory PageEntity({
    @required String id,
    @required String name,
    @required KtList<WidgetEntity> widgets,
  }) = _PageEntity;
}
