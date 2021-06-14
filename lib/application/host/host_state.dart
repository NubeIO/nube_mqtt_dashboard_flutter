part of 'host_cubit.dart';

@freezed
abstract class HostState with _$HostState {
  const factory HostState({
    @required ValueObject<String> host,
    @required ValueObject<int> port,
    @required InternalState<SetHostFailure> saveConfigState,
  }) = _Initial;

  factory HostState.initial() => HostState(
        host: ValueObject.none(),
        port: const ValueObject(Some(1617)),
        saveConfigState: const InternalState.initial(),
      );
}
