import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_manager.dart';
import 'package:monopoly_helper/core/utils/timer_helper.dart';
import 'package:monopoly_helper/core/utils/sound_helper.dart';

enum GameRunStatus {
  idle,
  running,
  paused,
  won,
  lost,
  timeOut,
}

class MiniGameState extends ChangeNotifier {
  final MiniGameManager _manager = MiniGameManager();
  BaseMiniGame? _currentGame;
  MiniGameDifficulty? _selectedDifficulty;

  GameRunStatus _status = GameRunStatus.idle;
  GameTimerController? _timerController;
  int _secondsLeft = 0;
  bool _isAnswerRevealed = false;

  // Stats
  int _totalChallengesPlayed = 0;
  int _totalWins = 0;

  MiniGameState() {
    // Select first game by default
    if (_manager.allGames.isNotEmpty) {
      selectGame(_manager.allGames.first);
    }
  }

  MiniGameManager get manager => _manager;
  BaseMiniGame? get currentGame => _currentGame;
  MiniGameDifficulty? get selectedDifficulty => _selectedDifficulty;
  GameRunStatus get status => _status;
  int get secondsLeft => _secondsLeft;
  int get totalSeconds => _currentGame?.timeLimitSeconds ?? 30;
  bool get isRunning => _status == GameRunStatus.running;
  bool get isAnswerRevealed => _isAnswerRevealed;
  int get totalChallengesPlayed => _totalChallengesPlayed;
  int get totalWins => _totalWins;

  List<BaseMiniGame> get filteredGames => _manager.getGamesByDifficulty(_selectedDifficulty);

  void setDifficultyFilter(MiniGameDifficulty? diff) {
    _selectedDifficulty = diff;
    final games = filteredGames;
    if (games.isNotEmpty && (_currentGame == null || _currentGame!.difficulty != diff && diff != null)) {
      selectGame(games.first);
    }
    notifyListeners();
  }

  void selectGame(BaseMiniGame game) {
    _timerController?.dispose();
    _currentGame = game;
    _currentGame!.generateNewChallenge();
    _status = GameRunStatus.idle;
    _isAnswerRevealed = false;
    _secondsLeft = game.timeLimitSeconds;

    _timerController = GameTimerController(
      totalSeconds: game.timeLimitSeconds,
      onTimeUp: () {
        _status = GameRunStatus.timeOut;
        SoundHelper.playFail();
        _totalChallengesPlayed++;
        notifyListeners();
      },
      onTick: (secs) {
        _secondsLeft = secs;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void pickRandomGame() {
    final game = _manager.getRandomGame(difficulty: _selectedDifficulty);
    selectGame(game);
    startTimer();
  }

  void newChallenge() {
    if (_currentGame == null) return;
    _isAnswerRevealed = false;
    _currentGame!.generateNewChallenge();
    resetTimer();
    notifyListeners();
  }

  void toggleAnswerReveal() {
    _isAnswerRevealed = !_isAnswerRevealed;
    notifyListeners();
  }

  void startTimer() {
    if (_currentGame == null) return;
    _status = GameRunStatus.running;
    _timerController?.start();
    SoundHelper.playTick();
    notifyListeners();
  }

  void pauseTimer() {
    _status = GameRunStatus.paused;
    _timerController?.pause();
    notifyListeners();
  }

  void resetTimer() {
    _status = GameRunStatus.idle;
    _timerController?.reset();
    _secondsLeft = totalSeconds;
    notifyListeners();
  }

  void markSuccess() {
    if (_status == GameRunStatus.won) return;
    _timerController?.stop();
    _status = GameRunStatus.won;
    SoundHelper.playSuccess();
    _totalChallengesPlayed++;
    _totalWins++;
    notifyListeners();
  }

  void markFail() {
    if (_status == GameRunStatus.lost) return;
    _timerController?.stop();
    _status = GameRunStatus.lost;
    SoundHelper.playFail();
    _totalChallengesPlayed++;
    notifyListeners();
  }

  @override
  void dispose() {
    _timerController?.dispose();
    super.dispose();
  }
}
