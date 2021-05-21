part of entities;

@freezed
abstract class AlertEntity with _$AlertEntity {
  const factory AlertEntity({
    @required KtList<Alert> alerts,
  }) = _AlertEntity;

  factory AlertEntity.empty() => const AlertEntity(
        alerts: KtList.empty(),
      );
}

@freezed
abstract class Alert with _$Alert {
  const factory Alert({
    @required DateTime timestamp,
    @required String title,
    @required String subtitle,
    @required String alertType,
    @required Priority priority,
  }) = _Alert;
}

@freezed
abstract class Priority with _$Priority {
  const factory Priority.high() = _HighPriority;
  const factory Priority.normal() = _NormalPriority;
  const factory Priority.low() = _LowPriority;
}
