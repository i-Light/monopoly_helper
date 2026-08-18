import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/theme/theme_provider.dart';
import 'package:monopoly_helper/core/widgets/difficulty_badge.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/features/home/state/mini_game_state.dart';

class GameSidebar extends StatelessWidget {
  final ValueChanged<BaseMiniGame>? onGameSelected;

  const GameSidebar({super.key, this.onGameSelected});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<MiniGameState>();
    final themeProvider = context.watch<ThemeProvider>();
    final games = gameState.filteredGames;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          left: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // App Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports_esports, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appTitle,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        AppStrings.appSubtitle,
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Difficulty Filter Horizontal Scroll
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text(AppStrings.allDifficulties, style: TextStyle(fontSize: 12)),
                    selected: gameState.selectedDifficulty == null,
                    showCheckmark: false,
                    onSelected: (_) => gameState.setDifficultyFilter(null),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    label: const Text(AppStrings.easy, style: TextStyle(fontSize: 12)),
                    selected: gameState.selectedDifficulty == MiniGameDifficulty.easy,
                    selectedColor: AppColors.easyTier.withOpacity(0.25),
                    showCheckmark: false,
                    onSelected: (_) => gameState.setDifficultyFilter(MiniGameDifficulty.easy),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    label: const Text(AppStrings.medium, style: TextStyle(fontSize: 12)),
                    selected: gameState.selectedDifficulty == MiniGameDifficulty.medium,
                    selectedColor: AppColors.mediumTier.withOpacity(0.25),
                    showCheckmark: false,
                    onSelected: (_) => gameState.setDifficultyFilter(MiniGameDifficulty.medium),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    label: const Text(AppStrings.hard, style: TextStyle(fontSize: 12)),
                    selected: gameState.selectedDifficulty == MiniGameDifficulty.hard,
                    selectedColor: AppColors.hardTier.withOpacity(0.25),
                    showCheckmark: false,
                    onSelected: (_) => gameState.setDifficultyFilter(MiniGameDifficulty.hard),
                  ),
                ],
              ),
            ),
          ),

          // Random Game Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ElevatedButton.icon(
              onPressed: () {
                gameState.pickRandomGame();
                if (onGameSelected != null && gameState.currentGame != null) {
                  onGameSelected!(gameState.currentGame!);
                }
              },
              icon: const Icon(Icons.shuffle, size: 18),
              label: const Text(AppStrings.randomGame, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1),

          // Mini Games List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                final isSelected = gameState.currentGame?.id == game.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Material(
                    color: isSelected ? game.difficulty.color.withOpacity(0.16) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        gameState.selectGame(game);
                        onGameSelected?.call(game);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? game.difficulty.color : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(game.icon, color: game.difficulty.color, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? game.difficulty.color : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${game.timeLimitSeconds} ${AppStrings.seconds}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            DifficultyBadge(difficulty: game.difficulty),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: AppColors.secondary, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'فوز: ${gameState.totalWins} / ${gameState.totalChallengesPlayed}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 18),
                  tooltip: 'التبديل بين الوضع الليلي والنهاري',
                  onPressed: () => themeProvider.toggleTheme(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
