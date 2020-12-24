import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/theme/theme_repository_interface.dart';
import '../../presentation/pages/preview/models/theme_option.dart';
import '../../presentation/themes/nube_theme.dart';
import '../validation/value_object.dart';

part 'preview_cubit.freezed.dart';
part 'preview_state.dart';

@injectable
class PreviewCubit extends Cubit<PreviewState> {
  final IThemeRepository _themeRepository;

  PreviewCubit(this._themeRepository) : super(PreviewState.initial()) {
    _init();
  }

  bool get enableInput =>
      state.theme.maybeMap(orElse: () => false, customTheme: (_) => true);

  void onThemeChange(Option<ThemeOption> value) {
    final theme = value.getOrElse(() => ThemeOption.defaultTheme());
    emit(state.copyWith(theme: theme.supportedTheme));
  }

  CustomThemeData get customThemeData => CustomThemeData(
        brightness: state.brightness.getOrCrash(),
        primary: state.primary.getOrCrash(),
        primaryLight: state.primaryLight.getOrCrash(),
        primaryDark: state.primaryDark.getOrCrash(),
        secondary: state.secondary.getOrCrash(),
        secondaryLight: state.secondaryLight.getOrCrash(),
        secondaryDark: state.secondaryDark.getOrCrash(),
        background: state.background.getOrCrash(),
        surface: state.surface.getOrCrash(),
        error: state.error.getOrCrash(),
        onPrimary: state.onPrimary.getOrCrash(),
        onSecondary: state.onSecondary.getOrCrash(),
        onBackground: state.onBackground.getOrCrash(),
        onSurface: state.onSurface.getOrCrash(),
        onError: state.onError.getOrCrash(),
      );

  Future<void> _init() async {
    final result = await _themeRepository.getTheme();

    result.fold((_) {}, (theme) {
      if (theme is CustomThemeData) {
        emit(state.copyWith(
          theme: theme,
          brightness: ValueObject(some(theme.brightness)),
          primary: ValueObject(some(theme.primary)),
          primaryLight: ValueObject(some(theme.primaryLight)),
          primaryDark: ValueObject(some(theme.primaryDark)),
          secondary: ValueObject(some(theme.secondary)),
          secondaryLight: ValueObject(some(theme.secondaryLight)),
          secondaryDark: ValueObject(some(theme.secondaryDark)),
          background: ValueObject(some(theme.background)),
          surface: ValueObject(some(theme.surface)),
          error: ValueObject(some(theme.error)),
          onPrimary: ValueObject(some(theme.onPrimary)),
          onSecondary: ValueObject(some(theme.onSecondary)),
          onBackground: ValueObject(some(theme.onBackground)),
          onSurface: ValueObject(some(theme.onSurface)),
          onError: ValueObject(some(theme.onError)),
        ));
      } else {
        emit(state.copyWith(theme: theme));
      }
    });
  }

  SupportedTheme _mapToTheme(
      CustomThemeData Function(CustomThemeData input) change) {
    return state.theme.map(
      defaultTheme: (theme) => theme,
      darkTheme: (theme) => theme,
      customTheme: (theme) => change(theme),
    );
  }

  void setBrightness(ValueObject<bool> value) {
    emit(state.copyWith(
      brightness: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          brightness: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setPrimary(ValueObject<int> value) {
    emit(state.copyWith(
      primary: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          primary: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setPrimaryLight(ValueObject<int> value) {
    emit(state.copyWith(
      primaryLight: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          primaryLight: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setPrimaryDark(ValueObject<int> value) {
    emit(state.copyWith(
      primaryDark: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          primaryDark: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setSecondary(ValueObject<int> value) {
    emit(state.copyWith(
      secondary: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          secondary: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setSecondaryLigh(ValueObject<int> value) {
    emit(state.copyWith(
      secondaryLight: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          secondaryLight: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setSecondaryDark(ValueObject<int> value) {
    emit(state.copyWith(
      secondaryDark: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          secondaryDark: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setBackground(ValueObject<int> value) {
    emit(state.copyWith(
      background: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          background: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setSurface(ValueObject<int> value) {
    emit(state.copyWith(
      surface: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          surface: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setError(ValueObject<int> value) {
    emit(state.copyWith(
      error: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          error: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setOnPrimary(ValueObject<int> value) {
    emit(state.copyWith(
      onPrimary: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          onPrimary: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setOnSecondary(ValueObject<int> value) {
    emit(state.copyWith(
      onSecondary: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          onSecondary: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setOnBackground(ValueObject<int> value) {
    emit(state.copyWith(
      onBackground: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          onBackground: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setOnSurface(ValueObject<int> value) {
    emit(state.copyWith(
      onSurface: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          onSurface: value.getOrCrash(),
        ),
      ),
    ));
  }

  void setOnError(ValueObject<int> value) {
    emit(state.copyWith(
      onError: value,
      theme: _mapToTheme(
        (theme) => theme.copyWith(
          onError: value.getOrCrash(),
        ),
      ),
    ));
  }

  Future<void> submit() async {
    final result = await _themeRepository.setTheme(state.theme);

    result.fold(
      (failure) => emit(
        state.copyWith(setState: InternalState.failure(failure)),
      ),
      (_) => emit(
        state.copyWith(setState: const InternalState.success()),
      ),
    );
  }
}
