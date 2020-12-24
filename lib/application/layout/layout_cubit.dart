import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/layout/entities.dart';
import '../../domain/layout/failures.dart';
import '../../domain/layout/layout_repository_interface.dart';

part 'layout_cubit.freezed.dart';
part 'layout_state.dart';

@injectable
class LayoutCubit extends Cubit<LayoutState> {
  final ILayoutRepository _layoutRepository;

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
        (layout) => emit(state.copyWith(
          layout: layout,
          layoutState: const InternalState.success(),
        )),
      );
    });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
