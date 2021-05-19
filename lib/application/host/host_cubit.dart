import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/core/internal_state.dart';
import '../../domain/network/failures.dart';
import '../../domain/network/host_repository_interface.dart';
import '../validation/value_object.dart';

part 'host_cubit.freezed.dart';
part 'host_state.dart';

@injectable
class HostCubit extends Cubit<HostState> {
  final IHostRepository _hostRepository;

  HostCubit(this._hostRepository) : super(HostState.initial());

  bool get isValid => state.host.isValid && state.port.isValid;

  void setHost(ValueObject<String> value) => emit(
        state.copyWith(
          host: value,
          saveConfigState: const InternalState.initial(),
        ),
      );

  void setPort(ValueObject<int> value) => emit(
        state.copyWith(
          port: value,
          saveConfigState: const InternalState.initial(),
        ),
      );

  Future<void> connect() async {
    emit(state.copyWith(saveConfigState: const InternalState.loading()));

    final host = state.host.getOrCrash();
    final port = state.port.getOrCrash();

    final result = await _hostRepository.setServerDetail(host, port);
    result.fold(
      (failue) => emit(
        state.copyWith(saveConfigState: InternalState.failure(failue)),
      ),
      (_) => emit(
        state.copyWith(saveConfigState: const InternalState.success()),
      ),
    );
  }
}
