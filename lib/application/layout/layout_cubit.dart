import 'package:bloc/bloc.dart';
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

  LayoutCubit(this._layoutRepository) : super(LayoutState.initial()) {
    init();
  }

  Future<void> init() async {
    _layoutRepository.layoutStream.listen((event) {
      event.fold(
        (failure) => emit(
          state.copyWith(layoutState: InternalState.failure(failure)),
        ),
        (layout) => emit(state.copyWith(
          layoutBuilder: layout,
          layoutState: const InternalState.success(),
        )),
      );
    });
  }
}
