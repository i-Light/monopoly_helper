import 'dart:math';
import 'base_mini_game.dart';
import 'mini_game_difficulty.dart';
import '../easy/fast_stop_bus_game.dart';
import '../easy/rhyme_challenge_game.dart';
import '../easy/short_reverse_word_game.dart';
import '../easy/speed_math_game.dart';
import '../medium/common_letter_finder_game.dart';
import '../medium/common_questions_logic_game.dart';
import '../medium/last_letter_word_chain_game.dart';
import '../medium/odd_one_out_game.dart';
import '../medium/word_ban_game.dart';
import '../hard/double_constraint_word_game.dart';
import '../hard/fitness_challenges_game.dart';
import '../hard/hard_stop_bus_game.dart';
import '../hard/stroop_effect_game.dart';
import '../hard/tongue_twisters_game.dart';

class MiniGameManager {
  static final MiniGameManager _instance = MiniGameManager._internal();
  factory MiniGameManager() => _instance;

  final List<BaseMiniGame> _games = [];

  MiniGameManager._internal() {
    _registerGames();
  }

  void _registerGames() {
    // Easy Tier (4 games)
    _games.add(FastStopBusGame());
    _games.add(RhymeChallengeGame());
    _games.add(ShortReverseWordGame());
    _games.add(SpeedMathGame());

    // Medium Tier (5 games)
    _games.add(CommonLetterFinderGame());
    _games.add(CommonQuestionsLogicGame());
    _games.add(LastLetterWordChainGame());
    _games.add(OddOneOutGame());
    _games.add(WordBanGame());

    // Hard Tier (5 games)
    _games.add(DoubleConstraintWordGame());
    _games.add(FitnessChallengesGame());
    _games.add(HardStopBusGame());
    _games.add(StroopEffectGame());
    _games.add(TongueTwistersGame());
  }

  List<BaseMiniGame> get allGames => List.unmodifiable(_games);

  List<BaseMiniGame> getGamesByDifficulty(MiniGameDifficulty? difficulty) {
    if (difficulty == null) return allGames;
    return _games.where((g) => g.difficulty == difficulty).toList();
  }

  BaseMiniGame getRandomGame({MiniGameDifficulty? difficulty}) {
    final candidateGames = getGamesByDifficulty(difficulty);
    final rand = Random();
    final selected = candidateGames[rand.nextInt(candidateGames.length)];
    selected.generateNewChallenge();
    return selected;
  }

  BaseMiniGame? getGameById(String id) {
    try {
      return _games.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
