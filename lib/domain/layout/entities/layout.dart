part of entities;

@freezed
abstract class LayoutEntity with _$LayoutEntity {
  const factory LayoutEntity({
    @required LayoutEntityConfig config,
    @required KtList<PageEntity> pages,
  }) = _LayoutEntity;

  factory LayoutEntity.empty() {
    return LayoutEntity(
      config: LayoutEntityConfig.empty(),
      pages: const KtList.empty(),
    );
  }
}

@freezed
abstract class LayoutEntityConfig with _$LayoutEntityConfig {
  const factory LayoutEntityConfig({
    @required bool persistData,
    @required bool showLoading,
  }) = _LayoutEntityConfig;

  factory LayoutEntityConfig.empty() => const LayoutEntityConfig(
        persistData: true,
        showLoading: false,
      );
}
