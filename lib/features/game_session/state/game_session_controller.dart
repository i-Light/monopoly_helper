import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/utils/sound_helper.dart';
import 'package:monopoly_helper/core/utils/timer_helper.dart';
import 'package:monopoly_helper/data/datasets/cities_data.dart';
import 'package:monopoly_helper/data/models/city_model.dart';
import 'package:monopoly_helper/data/models/player_model.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_manager.dart';

/// Which of the three looping screens is currently shown inside the main
/// frame.
enum TurnStage { movesSelection, challenge, results }

/// Where the current mini-game challenge stands.
enum ChallengeOutcome { undetermined, won, lost }

/// What ultimately happened to the player's move this turn — drives what
/// the results page shows (confetti or not, which city is "relevant").
enum MoveResolution { none, wonFree, paidToMove, stayed }

/// Owns every piece of state the turn loop (moves selection → challenge →
/// results → next player's moves selection ...) needs, plus the players
/// and the board's ownership state.
///
/// This is the single source of truth the three pages
/// (`MovesSelectionPage`, `ChallengePage`, `ResultsPage`) read from and
/// call into; none of them hold gameplay state themselves.
class GameSessionController extends ChangeNotifier {
  GameSessionController({List<PlayerModel>? players})
      : players = players ?? _defaultPlayers();

  final MiniGameManager _gameManager = MiniGameManager();
  final List<PlayerModel> players;

  static List<PlayerModel> _defaultPlayers() {
    const colors = [
      Color(0xFFE53935),
      Color(0xFF1E88E5),
      Color(0xFF43A047),
      Color(0xFFFB8C00),
    ];
    const names = ['لاعب 1', 'لاعب 2', 'لاعب 3'];
    return List.generate(
      names.length,
      (i) => PlayerModel(
        id: 'p$i',
        name: names[i],
        color: colors[i % colors.length],
        balance: GameConstants.defaultStartingCash,
      ),
    );
  }

  int activePlayerIndex = 0;
  TurnStage stage = TurnStage.movesSelection;
  int? selectedSteps;

  BaseMiniGame? currentGame;
  ChallengeOutcome challengeOutcome = ChallengeOutcome.undetermined;
  bool rulesExpanded = false;

  GameTimerController? _timerController;
  int secondsLeft = 0;
  bool isTimerRunning = false;

  MoveResolution moveResolution = MoveResolution.none;
  int? _destinationCityIndex;

  PlayerModel get activePlayer => players[activePlayerIndex];

  int get totalSeconds => currentGame?.timeLimitSeconds ?? 0;

  // ---------------------------------------------------------------------
  // Stage 1: moves selection
  // ---------------------------------------------------------------------

  /// Maps a chosen step count (1-9) to a mini-game difficulty tier, per
  /// the 3x3 grid's row banding: 1-3 easy, 4-6 medium, 7-9 hard.
  static MiniGameDifficulty difficultyForSteps(int steps) {
    if (steps <= 3) return MiniGameDifficulty.easy;
    if (steps <= 6) return MiniGameDifficulty.medium;
    return MiniGameDifficulty.hard;
  }

  void selectSteps(int steps) {
    selectedSteps = steps;
    _destinationCityIndex = (activePlayer.position + steps) % CitiesData.all.length;
    _startChallenge(_gameManager.getRandomGame(difficulty: difficultyForSteps(steps)));
    stage = TurnStage.challenge;
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Stage 2: challenge
  // ---------------------------------------------------------------------

  void _startChallenge(BaseMiniGame game) {
    _timerController?.dispose();
    currentGame = game;
    game.generateNewChallenge();
    challengeOutcome = ChallengeOutcome.undetermined;
    rulesExpanded = false;
    secondsLeft = game.timeLimitSeconds;
    isTimerRunning = false;

    _timerController = GameTimerController(
      totalSeconds: game.timeLimitSeconds,
      onTimeUp: () {
        isTimerRunning = false;
        challengeOutcome = ChallengeOutcome.lost;
        SoundHelper.playFail();
        notifyListeners();
      },
      onTick: (secs) {
        secondsLeft = secs;
        notifyListeners();
      },
    );
  }

  /// Opens from the "new challenge" button — lets the player manually
  /// swap to any other game regardless of the current challenge's state.
  void pickChallengeManually(BaseMiniGame game) {
    _startChallenge(game);
    notifyListeners();
  }

  void startTimer() {
    if (currentGame == null) return;
    isTimerRunning = true;
    _timerController?.start();
    SoundHelper.playTick();
    notifyListeners();
  }

  void pauseTimer() {
    isTimerRunning = false;
    _timerController?.pause();
    notifyListeners();
  }

  void resetTimer() {
    isTimerRunning = false;
    _timerController?.reset();
    secondsLeft = totalSeconds;
    notifyListeners();
  }

  void toggleRulesExpanded() {
    rulesExpanded = !rulesExpanded;
    notifyListeners();
  }

  void markChallengeWon() {
    if (challengeOutcome == ChallengeOutcome.won) return;
    isTimerRunning = false;
    _timerController?.stop();
    challengeOutcome = ChallengeOutcome.won;
    SoundHelper.playSuccess();
    notifyListeners();
  }

  void markChallengeLost() {
    if (challengeOutcome == ChallengeOutcome.lost) return;
    isTimerRunning = false;
    _timerController?.stop();
    challengeOutcome = ChallengeOutcome.lost;
    SoundHelper.playFail();
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Bottom action toolbar (concludes the challenge stage)
  // ---------------------------------------------------------------------

  void confirmWonMove() {
    moveResolution = MoveResolution.wonFree;
    stage = TurnStage.results;
    notifyListeners();
  }

  void chooseDontMove() {
    moveResolution = MoveResolution.stayed;
    stage = TurnStage.results;
    notifyListeners();
  }

  void confirmPaidMove() {
    activePlayer.balance -= currentGame?.penaltyAmount ?? 0;
    moveResolution = MoveResolution.paidToMove;
    stage = TurnStage.results;
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Stage 3: results — the "relevant" city and its ownership
  // ---------------------------------------------------------------------

  /// The city the results page's buy/pay UI operates on: the destination
  /// if the player moved this turn, otherwise wherever they already stand.
  int get relevantCityIndex =>
      moveResolution == MoveResolution.wonFree || moveResolution == MoveResolution.paidToMove
          ? _destinationCityIndex ?? activePlayer.position
          : activePlayer.position;

  CityModel get relevantCity => CitiesData.byIndex(relevantCityIndex);

  bool get playerMovedThisTurn =>
      moveResolution == MoveResolution.wonFree || moveResolution == MoveResolution.paidToMove;

  PlayerModel? get ownerOfRelevantCity {
    for (final player in players) {
      if (player.ownsCity(relevantCityIndex)) return player;
    }
    return null;
  }

  bool get relevantCityOwnedByOther {
    final owner = ownerOfRelevantCity;
    return owner != null && owner.id != activePlayer.id;
  }

  bool get canAffordBase => activePlayer.balance >= relevantCity.basePrice;
  bool get canAffordGarage => activePlayer.balance >= relevantCity.garagePrice;
  bool get canAffordMarket => activePlayer.balance >= relevantCity.marketPrice;

  void buyBase() {
    if (activePlayer.ownsCity(relevantCityIndex) || !canAffordBase) return;
    activePlayer.balance -= relevantCity.basePrice;
    activePlayer.ownedCityIndices.add(relevantCityIndex);
    notifyListeners();
  }

  void buyGarage() {
    if (activePlayer.ownsGarage(relevantCityIndex) || !canAffordGarage) return;
    activePlayer.balance -= relevantCity.garagePrice;
    activePlayer.ownedGarageIndices.add(relevantCityIndex);
    notifyListeners();
  }

  void buyMarket() {
    if (activePlayer.ownsMarket(relevantCityIndex) || !canAffordMarket) return;
    activePlayer.balance -= relevantCity.marketPrice;
    activePlayer.ownedMarketIndices.add(relevantCityIndex);
    notifyListeners();
  }

  /// Case: the relevant city belongs to another player — buy them out of
  /// the base plot outright, then end the turn.
  void buyFromOwner() {
    final owner = ownerOfRelevantCity;
    if (owner == null) return;
    final price = relevantCity.basePrice;
    activePlayer.balance -= price;
    owner.balance += price;
    owner.ownedCityIndices.remove(relevantCityIndex);
    activePlayer.ownedCityIndices.add(relevantCityIndex);
    endTurn();
  }

  /// Case: the relevant city belongs to another player — pay them rent
  /// instead of buying, then end the turn.
  void payOwnerAndFinishTurn() {
    final owner = ownerOfRelevantCity;
    if (owner == null) return;
    final fee = relevantCity.baseFee;
    activePlayer.balance -= fee;
    owner.balance += fee;
    endTurn();
  }

  /// "أنهى الدور" — used when the relevant city is unowned or already
  /// owned by the active player.
  void finishTurn() => endTurn();

  void endTurn() {
    if (playerMovedThisTurn) {
      activePlayer.position = relevantCityIndex;
    }
    activePlayerIndex = (activePlayerIndex + 1) % players.length;
    _resetForNextTurn();
  }

  void _resetForNextTurn() {
    _timerController?.dispose();
    _timerController = null;
    stage = TurnStage.movesSelection;
    selectedSteps = null;
    currentGame = null;
    challengeOutcome = ChallengeOutcome.undetermined;
    moveResolution = MoveResolution.none;
    _destinationCityIndex = null;
    rulesExpanded = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timerController?.dispose();
    super.dispose();
  }
}
