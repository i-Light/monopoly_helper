import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/mini_games/stop_the_bus_data.dart';

class FastStopBusGame extends BaseMiniGame {
  FastStopBusGame()
      : super(
          id: 'fast_stop_bus',
          title: AppStrings.gameFastStopBusTitle,
          description: AppStrings.gameFastStopBusDesc,
          rules: 'اذكر كلمة واحدة صحيحة تبدأ بالحرف المعطى لكل فئة من الفئات الثلاث قبل انتهاء الوقت.',
          difficulty: MiniGameDifficulty.easy,
          timeLimitSeconds: GameConstants.fastStopBusTime,
          rewardAmount: GameConstants.easyReward,
          penaltyAmount: GameConstants.easyPenalty,
          icon: Icons.directions_bus,
        );

  Map<String, dynamic>? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = StopTheBusData.generateRandomEasy();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    if (_currentChallenge == null) generateNewChallenge();
    final letter = _currentChallenge!['letter'] as String;

    return CustomCard(
      color: AppColors.easyTier.withValues(alpha: 0.12),
      borderColor: AppColors.easyTier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'الحرف المطلوب:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: AppColors.easyTier,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.easyTier.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
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
    final categories = (_currentChallenge ??= StopTheBusData.generateRandomEasy())['categories'] as List<String>;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'اذكر كلمة تبدأ بهذا الحرف لكل فئة:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        ...categories.map((cat) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.easyTier, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      cat,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onGameWon,
              icon: const Icon(Icons.check),
              label: const Text('أجاب بشكل صحيح'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: onGameLost,
              icon: const Icon(Icons.close),
              label: const Text('لم ينجح'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
