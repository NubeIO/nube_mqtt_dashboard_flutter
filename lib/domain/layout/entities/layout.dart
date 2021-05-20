part of entities;

@freezed
abstract class LayoutEntity with _$LayoutEntity {
  const factory LayoutEntity({
    @required LayoutEntityConfig config,
    @required KtList<PageEntity> pages,
    @required Logo logo,
    @required bool isEmptyState,
  }) = _LayoutEntity;

  factory LayoutEntity.empty({bool isEmptyState = false}) {
    return LayoutEntity(
      config: LayoutEntityConfig.empty(),
      pages: const KtList.empty(),
      logo: Logo.empty(),
      isEmptyState: isEmptyState,
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
