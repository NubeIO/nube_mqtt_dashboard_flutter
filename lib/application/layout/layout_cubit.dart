import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart' as dartz;
import 'package:nube_mqtt_dashboard/utils/logger/log.dart';
import 'package:nube_mqtt_dashboard/utils/timer/timeout_helper.dart';
import 'package:nube_mqtt_dashboard/utils/timer/timer_status.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/layout/entities.dart';
import '../../domain/layout/failures.dart';
import '../../domain/layout/layout_repository_interface.dart';

part 'layout_cubit.freezed.dart';
part 'layout_state.dart';

@injectable
class LayoutCubit extends Cubit<LayoutState> {
  final ILayoutRepository _layoutRepository;
  final TimeOutHelper _timeOutHelper = TimeOutHelper();

  StreamSubscription<Either<LayoutFailure, LayoutEntity>> subscription;

  LayoutCubit(this._layoutRepository) : super(LayoutState.initial()) {
    init(shouldReconnect: true);
  }

  Future<void> init({bool shouldReconnect = false}) async {
    emit(state.copyWith(layoutConnection: const InternalState.loading()));
    final result = await _layoutRepository.subscribe();

    result.fold(
      (failure) => emit(
        state.copyWith(
          layoutConnection: InternalState.failure(failure),
        ),
      ),
      (r) {
        if (shouldReconnect) {
          _listen();
        }
        emit(
          state.copyWith(layoutConnection: const InternalState.success()),
        );
      },
    );
  }

  void _listen() {
    if (subscription != null) {
      subscription.cancel();
      subscription = null;
    }
    subscription = _layoutRepository.layoutStream.listen((event) {
      event.fold(
        (failure) => emit(
          state.copyWith(layoutState: InternalState.failure(failure)),
        ),
        (layout) {
          final currentPage =
              _getPageFromId(state.selectedPage?.id, layout: layout);
          emit(state.copyWith(
            layout: layout,
            selectedPage: currentPage,
            layoutState: const InternalState.success(),
          ));
        },
      );
    });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    _timeOutHelper.cancel();
    return super.close();
  }

  void startTimeout(Config config) {
    Log.d("Page Timeout started with ${config.timeout}");
    if (config.timeout != null) {
      final duration = config.timeout.duration;
      _timeOutHelper.startCounter(
          duration: duration,
          callback: (status) {
            status.when(
              initial: () => emit(
                state.copyWith(pageTimeout: const TimerStatus.initial()),
              ),
              running: (duratiion) => emit(
                  state.copyWith(pageTimeout: TimerStatus.running(duration))),
              completed: (_) {
                final fallbackPage = _getPageFromId(config.timeout.fallbackId);
                emit(state.copyWith(
                  pageTimeout: TimerStatus<PageEntity>.completed(fallbackPage),
                  selectedPage: fallbackPage,
                ));
              },
            );
          });
    } else {
      _timeOutHelper.cancel();
      state.copyWith(pageTimeout: const TimerStatus.initial());
    }
  }

  PageEntity _getPageFromId(@nullable String id, {LayoutEntity layout}) {
    final dartz.KtList<PageEntity> pages = layout?.pages ?? state.layout.pages;
    return pages.asList().firstWhere(
          (element) => element.id == id,
          orElse: () => pages.firstOrNull(),
        );
  }

  void setSelected(PageEntity page) {
    emit(state.copyWith(selectedPage: page));
  }
}
