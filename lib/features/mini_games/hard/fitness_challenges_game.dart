import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/fitness_challenges_data.dart';

class FitnessChallengesGame extends BaseMiniGame {
  FitnessChallengesGame()
      : super(
          id: 'fitness_challenges',
          title: AppStrings.gameFitnessChallengesTitle,
          description: AppStrings.gameFitnessChallengesDesc,
          rules: 'قم بأداء التمرين الرياضي المطلوب بالعدد أو المدة المحددة قبل انتهاء العداد!',
          difficulty: MiniGameDifficulty.hard,
          timeLimitSeconds: GameConstants.fitnessTime,
          rewardAmount: GameConstants.hardReward,
          penaltyAmount: GameConstants.hardPenalty,
          icon: Icons.fitness_center,
        );

  FitnessChallengeItem? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = FitnessChallengesData.getRandom();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    final item = _currentChallenge ??= FitnessChallengesData.getRandom();

    return CustomCard(
      color: AppColors.hardTier.withValues(alpha: 0.12),
      borderColor: AppColors.hardTier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_run, color: AppColors.hardTier, size: 48),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.hardTier),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondary),
            ),
            child: Text(
              'الهدف: ${item.target}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.secondary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.instruction,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildInteractionWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  }) {
    final target = _currentChallenge?.repCountTarget;
    if (target != null) {
      return _RepCounter(target: target, onGameWon: onGameWon, onGameLost: onGameLost);
    }

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: onGameWon,
          icon: const Icon(Icons.check),
          label: const Text('أتم التمرين بنجاح'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
        ),
        ElevatedButton.icon(
          onPressed: onGameLost,
          icon: const Icon(Icons.close),
          label: const Text('توقف / إخفاق'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
        ),
      ],
    );
  }
}

/// A tap-to-count button for rep-based fitness challenges: each tap
/// counts one rep the player just did; hitting the target auto-wins.
class _RepCounter extends StatefulWidget {
  const _RepCounter({required this.target, required this.onGameWon, required this.onGameLost});

  final int target;
  final VoidCallback onGameWon;
  final VoidCallback onGameLost;

  @override
  State<_RepCounter> createState() => _RepCounterState();
}

class _RepCounterState extends State<_RepCounter> {
  int _count = 0;

  void _increment() {
    if (_count >= widget.target) return;
    setState(() => _count++);
    if (_count >= widget.target) widget.onGameWon();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$_count / ${widget.target}',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.hardTier),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _increment,
          icon: const Icon(Icons.add),
          label: const Text('عدت وحدة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.hardTier,
            minimumSize: const Size(200, 56),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: widget.onGameLost,
          icon: const Icon(Icons.close, color: AppColors.error),
          label: const Text('توقف / إخفاق', style: TextStyle(color: AppColors.error)),
        ),
      ],
    );
  }
}
