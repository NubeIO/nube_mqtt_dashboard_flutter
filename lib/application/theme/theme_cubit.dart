import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/theme/entities.dart';
import '../../domain/theme/failures.dart';
import '../../domain/theme/theme_repository_interface.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final IThemeRepository _themeRepository;
  ThemeCubit(this._themeRepository) : super(ThemeState.initial()) {
    _init();
  }

  StreamSubscription subscription;

  Future<void> _init() async {
    subscription = _themeRepository.getThemeStream().listen((event) {
      event.fold(
        (failure) => emit(state.copyWith(
          getState: InternalState.failure(failure),
        )),
        (theme) => emit(state.copyWith(
          theme: theme,
          getState: const InternalState.success(),
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
