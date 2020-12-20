part of entities;

@freezed
abstract class PinConfiguration with _$PinConfiguration {
  const factory PinConfiguration({
    @required String adminPin,
    @required String userPin,
  }) = _PinConfiguration;
}
