part of failures;

@freezed
abstract class NotificationFailure extends Failure with _$NotificationFailure {
  const factory NotificationFailure.unexpected() = _UnexpectedNotification;
}
