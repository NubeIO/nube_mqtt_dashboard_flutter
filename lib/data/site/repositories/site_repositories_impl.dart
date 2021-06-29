import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/site/site_data_source_interface.dart';
import '../../../domain/site/site_repository_interface.dart';
import '../../../utils/logger/log.dart';
import '../managers/site_preference_manager.dart';

const _TAG = "SiteRepository";

@LazySingleton(as: ISiteRepository)
class SiteRepositoryImpl extends ISiteRepository {
  final ISiteDataSource _siteDataSource;
  final SitePreferenceManager _sitePreferenceManager;

  final BehaviorSubject<KtList<Site>> _siteState = BehaviorSubject()
    ..listen((event) {
      Log.i("Sites $event", tag: _TAG);
    });

  final BehaviorSubject<Site> _activeSiteState = BehaviorSubject()
    ..listen((event) {
      Log.i("Active $event", tag: _TAG);
    });

  SiteRepositoryImpl(
    this._siteDataSource,
    this._sitePreferenceManager,
  );

  @override
  Future<Either<GetSiteFailure, KtList<Site>>> fetchSites() {
    return futureFailureHelper(
      request: () async {
        final sites = await _siteDataSource.getSites();
        _siteState.add(sites);
        _sitePreferenceManager.sites = sites;
        if (_sitePreferenceManager.active == null && sites.isNotEmpty()) {
          _activeSiteState.add(sites.first());
        }
        return Right(sites);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const GetSiteFailure.connection(),
        general: (message) => GetSiteFailure.general(message),
        orElse: () => const GetSiteFailure.server(),
      ),
    );
  }

  @override
  Future<Either<SetSiteFailure, Unit>> setSite(String uuid) async {
    final active = _siteState.value.find((site) => site.uuid == uuid);

    if (active != null) {
      if (active.uuid == _sitePreferenceManager.active?.uuid) {
        return const Right(unit);
      }
      _sitePreferenceManager.active = active;
      _activeSiteState.add(active);
      return const Right(unit);
    }
    return const Left(SetSiteFailure.unexpected());
  }

  @override
  Stream<Either<SiteFailure, KtList<Site>>> get sitesStream async* {
    final sites = _sitePreferenceManager.sites;
    yield Right(sites ?? const KtList.empty());

    yield* _siteState.stream.distinct().map((event) => Right(event));
  }

  @override
  Stream<Either<SiteFailure, Site>> get activeSiteStream async* {
    final activeSite = _sitePreferenceManager.active;
    if (activeSite != null) {
      yield Right(activeSite);
    }

    yield* _activeSiteState.stream.distinct().map((event) => Right(event));
  }

  @override
  Future<Unit> clearData() async {
    await _sitePreferenceManager.clearData();
    return unit;
  }
}
