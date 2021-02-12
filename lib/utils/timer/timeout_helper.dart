import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nube_mqtt_dashboard/domain/session/session_repository_interface.dart';
import 'package:nube_mqtt_dashboard/utils/logger/log.dart';
import 'package:nube_mqtt_dashboard/utils/timer/timer_status.dart';

class TimeOutHelper {
  @nullable
  final Duration _interval;

  Duration _currentDuration;
  Timer _timer;

  TimeOutHelper({
    Duration interval = const Duration(seconds: 1),
  }) : _interval = interval;

  void _onComplete() {
    Log.d("Timer Completed");
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void cancel() {
    Log.d("Timer Cancelled");
    _onComplete();
  }

  void startCounter({
    @required Duration duration,
    @required Function(TimerStatus status) callback,
  }) {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    final durationInMicro = duration;
    Log.d("Timer started for ${durationInMicro.inSeconds} seconds");

    _currentDuration = duration;
    callback(TimerStatus.running(_currentDuration));

    _timer = Timer.periodic(_interval, (timer) {
      _currentDuration = durationInMicro - _interval * timer.tick;
      if (_currentDuration.isNegative) {
        Log.d("Timer Completed");
        _onComplete();
        callback(const TimerStatus.completed(unit));
      } else {
        Log.d("Timer Running $_currentDuration");
      }
    });
  }
}
