import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/utils/timer_helper.dart';
import 'package:monopoly_helper/data/models/player_model.dart';

enum GamePlayState {
  notStarted,
  inProgress,
  won,
  lost,
  timeOut,
}

class MiniGameSession extends ChangeNotifier {
  final BaseMiniGame game;
  final PlayerModel challenger;
  GamePlayState _state = GamePlayState.notStarted;
  late GameTimerController _timerController;
  int _secondsLeft;

  MiniGameSession({
    required this.game,
    required this.challenger,
  }) : _secondsLeft = game.timeLimitSeconds {
    _timerController = GameTimerController(
      totalSeconds: game.timeLimitSeconds,
      onTimeUp: _handleTimeout,
      onTick: (secs) {
        _secondsLeft = secs;
        notifyListeners();
      },
    );
  }

  GamePlayState get state => _state;
  int get secondsLeft => _secondsLeft;
  int get totalSeconds => game.timeLimitSeconds;
  bool get isRunning => _state == GamePlayState.inProgress;

  void start() {
    _state = GamePlayState.inProgress;
    game.generateNewChallenge();
    _timerController.start();
    notifyListeners();
  }

  void markWon() {
    if (_state != GamePlayState.inProgress) return;
    _timerController.stop();
    _state = GamePlayState.won;
    notifyListeners();
  }

  void markLost() {
    if (_state != GamePlayState.inProgress) return;
    _timerController.stop();
    _state = GamePlayState.lost;
    notifyListeners();
  }

  void _handleTimeout() {
    _state = GamePlayState.timeOut;
    notifyListeners();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }
}
