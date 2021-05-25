part of entities;

@freezed
abstract class NotificationData with _$NotificationData {
  const factory NotificationData.verification() = _VerificationNotification;
  const factory NotificationData.unknown({
    @required dynamic data,
  }) = _UnknownNotification;
}
