import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/site/site_repository_interface.dart';
import '../../utils/logger/log.dart';

part 'site_cubit.freezed.dart';
part 'site_state.dart';

const _TAG = "SiteCubit";

@injectable
class SiteCubit extends Cubit<SiteState> {
  final ISiteRepository _siteRepository;

  SiteCubit(
    this._siteRepository,
  ) : super(SiteState.initial()) {
    _siteRepository.sitesStream.listen((event) {
      Log.d("Sites $event", tag: _TAG);
    });

    _siteRepository.activeSiteStream.listen((event) {
      Log.d("Active Site $event", tag: _TAG);
    });

    Rx.combineLatest<dynamic, Either<SiteFailure, KtList<SimpleSite>>>(
      [_siteRepository.sitesStream, _siteRepository.activeSiteStream],
      (values) {
        final siteResult = values.first as Either<SiteFailure, KtList<Site>>;
        final activeSiteResult = values.last as Either<SiteFailure, Site>;

        KtList<SimpleSite> sites;
        if (siteResult.isLeft() && activeSiteResult.isLeft()) {
          return const Left(SiteFailure.unexpected());
        }
        if (siteResult.isLeft()) {
          sites = activeSiteResult.fold(
            (l) => const KtList.empty(),
            (site) => KtList.from([fromSite(site, isSelected: true)]),
          );
        } else {
          final siteList = siteResult.fold((l) => throw AssertionError(), id);
          sites = activeSiteResult.fold(
            (l) => siteList.mapIndexed(
              (index, site) => fromSite(site, isSelected: index == 0),
            ),
            (active) {
              return siteList.map(
                (site) => fromSite(site, isSelected: site.uuid == active.uuid),
              );
            },
          );
        }
        return Right(sites);
      },
    ).listen((event) {
      event.fold(
        (failure) => emit(
          state.copyWith(siteState: InternalStateValue.failure(failure)),
        ),
        (sites) => emit(
          state.copyWith(siteState: InternalStateValue.success(sites)),
        ),
      );
    });
  }

  Future<void> setSite(String id) async {
    emit(state.copyWith(saveState: const InternalState.loading()));

    final result = await _siteRepository.setSite(id);

    result.fold(
      (failure) => emit(
        state.copyWith(saveState: InternalState.failure(failure)),
      ),
      (sites) => emit(
        state.copyWith(saveState: const InternalState.success()),
      ),
    );
  }
}
