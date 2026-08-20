import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/stop_the_bus_data.dart';

class HardStopBusGame extends BaseMiniGame {
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

  Map<String, dynamic>? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = StopTheBusData.generateRandomHard();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    final letter = (_currentChallenge ??= StopTheBusData.generateRandomHard())['letter'] as String;

    return CustomCard(
      color: AppColors.hardTier.withValues(alpha: 0.12),
      borderColor: AppColors.hardTier,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    );
  }

  @override
  Widget buildInteractionWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  }) {
    final categories = (_currentChallenge ??= StopTheBusData.generateRandomHard())['categories'] as List<String>;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.center,
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
