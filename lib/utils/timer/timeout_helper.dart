import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/session/session_repository_interface.dart';
import '../logger/log.dart';
import 'timer_status.dart';

const _TAG = "TimeOutHelper";

class TimeOutHelper {
  @nullable
  final Duration _interval;

  Duration _currentDuration;
  Timer _timer;

  TimeOutHelper({
    Duration interval = const Duration(seconds: 1),
  }) : _interval = interval;

  void _onComplete() {
    Log.i("Timer Completed", tag: _TAG);
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void cancel() {
    Log.i("Timer Cancelled", tag: _TAG);
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
    Log.i("Timer started for ${durationInMicro.inSeconds} seconds", tag: _TAG);

    _currentDuration = duration;
    callback(TimerStatus.running(_currentDuration));

    _timer = Timer.periodic(_interval, (timer) {
      _currentDuration = durationInMicro - _interval * timer.tick;
      if (_currentDuration.isNegative) {
        Log.i("Timer Completed", tag: _TAG);
        _onComplete();
        callback(const TimerStatus.completed(unit));
      } else {
        Log.i("Timer Running $_currentDuration", tag: _TAG);
      }
    });
  }
}
