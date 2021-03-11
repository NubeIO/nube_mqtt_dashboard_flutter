import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/log/entities.dart';
import '../../domain/log/log_repository_interface.dart';

part 'log_cubit.freezed.dart';
part 'log_state.dart';

@injectable
class LogCubit extends Cubit<LogState> {
  final ILogRepository _logRepository;

  LogCubit(this._logRepository) : super(LogState.initial()) {
    init();
  }

  void init() {
    _logRepository.logStream.listen((event) {
      event.fold(
        (failure) => emit(
          state.copyWith(
            streamState: InternalState.failure(failure),
          ),
        ),
        (logs) => emit(
          state.copyWith(
            logs: logs,
            streamState: const InternalState.success(),
          ),
        ),
      );
    });
  }
}
