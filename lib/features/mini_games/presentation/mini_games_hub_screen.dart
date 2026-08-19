import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/core/widgets/difficulty_badge.dart';
import 'package:monopoly_helper/features/player_management/state/player_provider.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_manager.dart';
import 'package:monopoly_helper/features/mini_games/presentation/mini_game_runner_screen.dart';

class MiniGamesHubScreen extends StatefulWidget {
  const MiniGamesHubScreen({super.key});

  @override
  State<MiniGamesHubScreen> createState() => _MiniGamesHubScreenState();
}

class _MiniGamesHubScreenState extends State<MiniGamesHubScreen> {
  MiniGameDifficulty? _selectedDifficulty;

  void _launchGame(BaseMiniGame game) {
    final playerProvider = context.read<PlayerProvider>();
    if (playerProvider.activePlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة لاعبين أولاً لبدء التحدي')),
      );
      return;
    }

    final challenger = playerProvider.currentTurnPlayer ?? playerProvider.activePlayers.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MiniGameRunnerScreen(
          game: game,
          challenger: challenger,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = MiniGameManager();
    final filteredGames = manager.getGamesByDifficulty(_selectedDifficulty);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.miniGamesHub),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text(AppStrings.allDifficulties),
                    selected: _selectedDifficulty == null,
                    onSelected: (_) => setState(() => _selectedDifficulty = null),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text(AppStrings.easy),
                    selected: _selectedDifficulty == MiniGameDifficulty.easy,
                    selectedColor: AppColors.easyTier.withValues(alpha: 0.25),
                    checkmarkColor: AppColors.easyTier,
                    onSelected: (_) => setState(() => _selectedDifficulty = MiniGameDifficulty.easy),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text(AppStrings.medium),
                    selected: _selectedDifficulty == MiniGameDifficulty.medium,
                    selectedColor: AppColors.mediumTier.withValues(alpha: 0.25),
                    checkmarkColor: AppColors.mediumTier,
                    onSelected: (_) => setState(() => _selectedDifficulty = MiniGameDifficulty.medium),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text(AppStrings.hard),
                    selected: _selectedDifficulty == MiniGameDifficulty.hard,
                    selectedColor: AppColors.hardTier.withValues(alpha: 0.25),
                    checkmarkColor: AppColors.hardTier,
                    onSelected: (_) => setState(() => _selectedDifficulty = MiniGameDifficulty.hard),
                  ),
                ],
              ),
            ),
          ),

          // Random Picker Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                final randomGame = manager.getRandomGame(difficulty: _selectedDifficulty);
                _launchGame(randomGame);
              },
              icon: const Icon(Icons.shuffle, size: 22),
              label: const Text(AppStrings.randomMiniGame),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),

          // Games Grid
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredGames.length,
              itemBuilder: (context, index) {
                final game = filteredGames[index];
                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: () => _launchGame(game),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: game.difficulty.color.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(game.icon, color: game.difficulty.color, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    game.title,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DifficultyBadge(difficulty: game.difficulty),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              game.description,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.timer, size: 14, color: Colors.grey.shade400),
                                const SizedBox(width: 4),
                                Text('${game.timeLimitSeconds} ثانية', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(width: 14),
                                const Icon(Icons.card_giftcard, size: 14, color: AppColors.cashGold),
                                const SizedBox(width: 4),
                                Text('+${game.rewardAmount}£ / -${game.penaltyAmount}£', style: const TextStyle(fontSize: 12, color: AppColors.cashGold, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
