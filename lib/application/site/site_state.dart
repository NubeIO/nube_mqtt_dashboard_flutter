part of 'site_cubit.dart';

@freezed
abstract class SiteState with _$SiteState {
  const factory SiteState({
    @required InternalStateValue<SiteFailure, KtList<SimpleSite>> siteState,
    @required InternalState<SetSiteFailure> saveState,
  }) = _Initial;

  // ignore: prefer_const_constructors
  factory SiteState.initial() => SiteState(
        siteState: const InternalStateValue.initial(),
        saveState: const InternalState.initial(),
      );
}

@freezed
abstract class SimpleSite with _$SimpleSite {
  const factory SimpleSite({
    @required String id,
    @required String name,
    @required bool isSelected,
  }) = _SimpleSite;
}

SimpleSite fromSite(
  Site site, {
  bool isSelected = false,
}) =>
    SimpleSite(
      id: site.uuid,
      name: site.name,
      isSelected: isSelected,
    );
