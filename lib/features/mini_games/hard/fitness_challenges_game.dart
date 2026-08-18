import 'package:flutter/material.dart';
import '../core/base_mini_game.dart';
import '../core/mini_game_difficulty.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/datasets/fitness_challenges_data.dart';

class FitnessChallengesGame extends BaseMiniGame {
  FitnessChallengeItem? _currentChallenge;

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

  @override
  void generateNewChallenge() {
    _currentChallenge = FitnessChallengesData.getRandom();
  }

  @override
  Widget buildChallengeWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  }) {
    if (_currentChallenge == null) generateNewChallenge();
    final item = _currentChallenge!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          color: AppColors.hardTier.withOpacity(0.12),
          borderColor: AppColors.hardTier,
          child: Column(
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
                  color: AppColors.secondary.withOpacity(0.2),
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
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ),
      ],
    );
  }
}
