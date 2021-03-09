part of entities;

@freezed
abstract class PageEntity with _$PageEntity {
  const factory PageEntity({
    @required String id,
    @required String relativePath,
    @required String name,
    @required Config config,
    @required KtList<PageEntity> pages,
    @required KtList<WidgetEntity> widgets,
  }) = _PageEntity;
}

@freezed
abstract class Config with _$Config {
  const factory Config({
    @required bool protected,
    PageTimeout timeout,
  }) = _Config;
}

@freezed
abstract class PageTimeout with _$PageTimeout {
  const factory PageTimeout({
    String fallbackId,
    Duration duration,
  }) = _PageTimeout;
}
