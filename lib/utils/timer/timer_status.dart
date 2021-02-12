import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_status.freezed.dart';

@freezed
abstract class TimerStatus<T> with _$TimerStatus {
  const factory TimerStatus.initial() = _Initial;
  const factory TimerStatus.running(Duration duration) = _Running;
  const factory TimerStatus.completed(T payload) = _Completed;
}
