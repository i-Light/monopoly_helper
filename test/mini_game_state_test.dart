import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_helper/features/home/state/mini_game_state.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';

void main() {
  group('MiniGameState Controller Tests', () {
    late MiniGameState state;

    setUp(() {
      state = MiniGameState();
    });

    test('Initializes with default first game', () {
      expect(state.currentGame, isNotNull);
      expect(state.manager.allGames.length, 14);
    });

    test('Filter by difficulty updates available games list', () {
      state.setDifficultyFilter(MiniGameDifficulty.easy);
      expect(state.filteredGames.length, 4);

      state.setDifficultyFilter(MiniGameDifficulty.medium);
      expect(state.filteredGames.length, 5);

      state.setDifficultyFilter(MiniGameDifficulty.hard);
      expect(state.filteredGames.length, 5);

      state.setDifficultyFilter(null);
      expect(state.filteredGames.length, 14);
    });

    test('Score tracking updates upon win or loss', () {
      final initialPlayed = state.totalChallengesPlayed;
      final initialWins = state.totalWins;

      state.markSuccess();
      expect(state.totalChallengesPlayed, initialPlayed + 1);
      expect(state.totalWins, initialWins + 1);
      expect(state.status, GameRunStatus.won);

      state.markFail();
      expect(state.totalChallengesPlayed, initialPlayed + 2);
      expect(state.totalWins, initialWins + 1);
      expect(state.status, GameRunStatus.lost);
    });
  });
}
