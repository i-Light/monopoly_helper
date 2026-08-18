import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_manager.dart';

void main() {
  group('MiniGameManager Tests', () {
    final manager = MiniGameManager();

    test('Registers exactly 14 mini-games', () {
      expect(manager.allGames.length, 14);
    });

    test('Categorizes games into Easy, Medium, and Hard tiers', () {
      final easyGames = manager.getGamesByDifficulty(MiniGameDifficulty.easy);
      final mediumGames = manager.getGamesByDifficulty(MiniGameDifficulty.medium);
      final hardGames = manager.getGamesByDifficulty(MiniGameDifficulty.hard);

      expect(easyGames.length, 4);
      expect(mediumGames.length, 5);
      expect(hardGames.length, 5);
      expect(easyGames.length + mediumGames.length + hardGames.length, 14);
    });

    test('Random game selector returns non-null challenge', () {
      final game = manager.getRandomGame(difficulty: MiniGameDifficulty.easy);
      expect(game.difficulty, MiniGameDifficulty.easy);
      expect(game.id.isNotEmpty, true);
    });
  });
}
