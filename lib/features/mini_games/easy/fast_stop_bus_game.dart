import 'package:flutter/material.dart';
import '../core/base_mini_game.dart';
import '../core/mini_game_difficulty.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/datasets/stop_the_bus_data.dart';

class FastStopBusGame extends BaseMiniGame {
  Map<String, dynamic>? _currentChallenge;

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

  @override
  void generateNewChallenge() {
    _currentChallenge = StopTheBusData.generateRandomEasy();
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
          color: AppColors.easyTier.withOpacity(0.12),
          borderColor: AppColors.easyTier,
          child: Column(
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
                      color: AppColors.easyTier.withOpacity(0.4),
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
        ),
        const SizedBox(height: 16),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
