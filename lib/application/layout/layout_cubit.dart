import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/layout/entities.dart';
import '../../domain/layout/failures.dart';
import '../../domain/layout/layout_repository_interface.dart';
import '../../utils/logger/log.dart';
import '../../utils/timer/timeout_helper.dart';
import '../../utils/timer/timer_status.dart';

part 'layout_cubit.freezed.dart';
part 'layout_state.dart';

const _TAG = "LayoutCubit";

@injectable
class LayoutCubit extends Cubit<LayoutState> {
  final ILayoutRepository _layoutRepository;
  final TimeOutHelper _timeOutHelper = TimeOutHelper();

  StreamSubscription<Either<LayoutFailure, LayoutEntity>> subscription;

  LayoutCubit(this._layoutRepository) : super(LayoutState.initial()) {
    _listen();
  }

  void _listen() {
    subscription = _layoutRepository.layoutStream.listen((event) {
      _onLayoutChange(event);
    });
  }

  void _onLayoutChange(Either<LayoutFailure, LayoutEntity> event) {
    event.fold(
      (failure) => emit(
        state.copyWith(
          layoutState: InternalState.failure(failure),
          layoutConnection: const InternalState.success(),
        ),
      ),
      (layout) {
        final currentPage = _getPageFromId(
          state.selectedPage?.id,
          layout: layout,
        );
        emit(state.copyWith(
          layout: layout,
          pages: nestedPages(layout.pages),
          selectedPage: currentPage,
          layoutState: const InternalState.success(),
          layoutConnection: const InternalState.success(),
        ));
      },
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    _timeOutHelper.cancel();
    return super.close();
  }

  void startTimeout(Config config) {
    Log.d("Page Timeout started with ${config.timeout}", tag: _TAG);
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

  PageEntity _getPageFromId(
    String id, {
    LayoutEntity layout,
  }) {
    final KtList<PageEntity> pages = nestedPages(layout?.pages ?? emptyList())
        .plus(nestedPages(state.layout.pages));
    return pages.asList().firstWhere(
          (element) => element.id == id,
          orElse: () => nestedPages(pages).firstOrNull(),
        );
  }

  void setSelected(PageEntity page) {
    emit(state.copyWith(selectedPage: page));
  }
}

// Remove all empty pages
KtList<PageEntity> nestedPages(KtList<PageEntity> pages) {
  return pages.fold(
    mutableListOf(),
    (acc, it) => acc
        .plusElement(it)
        .plus(nestedPages(it.pages))
        .filter((it) => it.widgets.isNotEmpty()),
  );
}
