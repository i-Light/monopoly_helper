import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/core/widgets/difficulty_badge.dart';
import 'package:monopoly_helper/core/widgets/game_timer_widget.dart';
import 'package:monopoly_helper/features/home/state/mini_game_state.dart';

class GameStagePanel extends StatelessWidget {
  const GameStagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<MiniGameState>();
    final game = gameState.currentGame;

    if (game == null) {
      return const Center(
        child: Text(
          AppStrings.selectGame,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 620;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isCompact ? 12 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card: Game Title, Difficulty, and Timer
              CustomCard(
                padding: EdgeInsets.all(isCompact ? 12 : 16),
                child: isCompact
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: game.difficulty.color.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(game.icon, color: game.difficulty.color, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      game.title,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    DifficultyBadge(difficulty: game.difficulty),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            game.description,
                            style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          // Timer and controls centered
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GameTimerWidget(
                                remainingSeconds: gameState.secondsLeft,
                                totalSeconds: gameState.totalSeconds,
                                isRunning: gameState.isRunning,
                                size: 70,
                              ),
                              const SizedBox(width: 16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!gameState.isRunning)
                                    IconButton.filled(
                                      icon: const Icon(Icons.play_arrow, size: 22),
                                      style: IconButton.styleFrom(backgroundColor: AppColors.success),
                                      tooltip: AppStrings.startTimer,
                                      onPressed: () => gameState.startTimer(),
                                    )
                                  else
                                    IconButton.filled(
                                      icon: const Icon(Icons.pause, size: 22),
                                      style: IconButton.styleFrom(backgroundColor: AppColors.warning),
                                      tooltip: AppStrings.pauseTimer,
                                      onPressed: () => gameState.pauseTimer(),
                                    ),
                                  const SizedBox(width: 8),
                                  IconButton.outlined(
                                    icon: const Icon(Icons.refresh, size: 20),
                                    tooltip: AppStrings.resetTimer,
                                    onPressed: () => gameState.resetTimer(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: game.difficulty.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(game.icon, color: game.difficulty.color, size: 36),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      game.title,
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    DifficultyBadge(difficulty: game.difficulty),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  game.description,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Interactive Circular Timer on Desktop
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GameTimerWidget(
                                remainingSeconds: gameState.secondsLeft,
                                totalSeconds: gameState.totalSeconds,
                                isRunning: gameState.isRunning,
                                size: 80,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!gameState.isRunning)
                                    IconButton(
                                      icon: const Icon(Icons.play_arrow, color: AppColors.success, size: 22),
                                      tooltip: AppStrings.startTimer,
                                      onPressed: () => gameState.startTimer(),
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(Icons.pause, color: AppColors.warning, size: 22),
                                      tooltip: AppStrings.pauseTimer,
                                      onPressed: () => gameState.pauseTimer(),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh, color: Colors.grey, size: 20),
                                    tooltip: AppStrings.resetTimer,
                                    onPressed: () => gameState.resetTimer(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),

              // Rules Banner
              CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'القواعد: ${game.rules}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Main Challenge Arena
              Container(
                padding: EdgeInsets.all(isCompact ? 14 : 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: game.difficulty.color.withOpacity(0.35), width: 1.5),
                ),
                child: game.buildChallengeWidget(
                  context,
                  onGameWon: () => gameState.markSuccess(),
                  onGameLost: () => gameState.markFail(),
                ),
              ),
              const SizedBox(height: 14),

              // Bottom Action Toolbar (Wrap to prevent overflow on mobile)
              CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => gameState.newChallenge(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text(AppStrings.newChallenge),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => gameState.markSuccess(),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text(AppStrings.markSuccess),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => gameState.markFail(),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text(AppStrings.markFail),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
