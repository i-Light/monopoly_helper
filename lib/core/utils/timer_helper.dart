import 'dart:async';
import 'package:flutter/material.dart';

class GameTimerController {
  final int totalSeconds;
  final VoidCallback onTimeUp;
  final ValueChanged<int>? onTick;

  Timer? _timer;
  int _remainingSeconds;
  bool _isRunning = false;

  GameTimerController({
    required this.totalSeconds,
    required this.onTimeUp,
    this.onTick,
  }) : _remainingSeconds = totalSeconds;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  double get progress => _remainingSeconds / (totalSeconds > 0 ? totalSeconds : 1);

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        onTick?.call(_remainingSeconds);
      } else {
        stop();
        onTimeUp();
      }
    });
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
  }

  void reset() {
    pause();
    _remainingSeconds = totalSeconds;
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
  }

  void dispose() {
    stop();
  }
}
