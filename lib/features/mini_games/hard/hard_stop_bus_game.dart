import 'package:flutter/material.dart';
import '../core/base_mini_game.dart';
import '../core/mini_game_difficulty.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/datasets/stop_the_bus_data.dart';

class HardStopBusGame extends BaseMiniGame {
  Map<String, dynamic>? _currentChallenge;

  HardStopBusGame()
      : super(
          id: 'hard_stop_bus',
          title: AppStrings.gameHardStopBusTitle,
          description: AppStrings.gameHardStopBusDesc,
          rules: 'تحدي موسع: اذكر 5 كلمات تبدأ بالحرف المحدد لـ 5 فئات متقدمة قبل انتهاء الوقت!',
          difficulty: MiniGameDifficulty.hard,
          timeLimitSeconds: GameConstants.hardStopBusTime,
          rewardAmount: GameConstants.hardReward,
          penaltyAmount: GameConstants.hardPenalty,
          icon: Icons.directions_bus_filled,
        );

  @override
  void generateNewChallenge() {
    _currentChallenge = StopTheBusData.generateRandomHard();
  }

  @override
  Widget buildChallengeWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  }) {
    if (_currentChallenge == null) generateNewChallenge();
    final letter = _currentChallenge!['letter'] as String;
    final categories = _currentChallenge!['categories'] as List<String>;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          color: AppColors.hardTier.withOpacity(0.12),
          borderColor: AppColors.hardTier,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'الحرف:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 14),
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: AppColors.hardTier,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...categories.map((cat) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.hardTier, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      cat,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: onGameWon,
              icon: const Icon(Icons.check),
              label: const Text('أكمل الـ 5 فئات'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
            ElevatedButton.icon(
              onPressed: onGameLost,
              icon: const Icon(Icons.close),
              label: const Text('لم يكتمل'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            ),
          ],
        ),
      ],
    );
  }
}
