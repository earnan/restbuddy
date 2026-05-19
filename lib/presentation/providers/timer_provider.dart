import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimerStatus { idle, counting, paused, resting }

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

class TimerState {
  final TimerStatus status;
  final int remainingSeconds;
  final int totalSeconds;

  const TimerState({
    this.status = TimerStatus.idle,
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
  });

  TimerState copyWith({
    TimerStatus? status,
    int? remainingSeconds,
    int? totalSeconds,
  }) {
    return TimerState(
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier() : super(const TimerState());

  void startCountdown(int seconds) {
    _timer?.cancel();
    state = TimerState(
      status: TimerStatus.counting,
      remainingSeconds: seconds,
      totalSeconds: seconds,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 0) {
        _timer?.cancel();
        state = state.copyWith(status: TimerStatus.resting);
        // TODO: 触发休息提醒
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resume() {
    state = state.copyWith(status: TimerStatus.counting);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 0) {
        _timer?.cancel();
        state = state.copyWith(status: TimerStatus.resting);
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });
  }

  void reset() {
    _timer?.cancel();
    state = const TimerState();
  }

  void startRest(int seconds) {
    _timer?.cancel();
    state = TimerState(
      status: TimerStatus.resting,
      remainingSeconds: seconds,
      totalSeconds: seconds,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 0) {
        _timer?.cancel();
        state = const TimerState();
        // TODO: 记录休息完成
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
