import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/speed_math_data.dart';

class SpeedMathGame extends BaseMiniGame {
  MathChallenge? _currentChallenge;

  SpeedMathGame()
      : super(
          id: 'speed_math',
          title: AppStrings.gameSpeedMathTitle,
          description: AppStrings.gameSpeedMathDesc,
          rules: 'احسب الناتج الرياضي ذهنياً واختر الإجابة الصحيحة قبل انتهاء العداد!',
          difficulty: MiniGameDifficulty.easy,
          timeLimitSeconds: GameConstants.speedMathTime,
          rewardAmount: GameConstants.easyReward,
          penaltyAmount: GameConstants.easyPenalty,
          icon: Icons.calculate,
        );

  @override
  void generateNewChallenge() {
    _currentChallenge = SpeedMathData.generateChallenge();
  }

  @override
  Widget buildChallengeWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  }) {
    if (_currentChallenge == null) generateNewChallenge();
    final challenge = _currentChallenge!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          color: AppColors.easyTier.withValues(alpha: 0.12),
          borderColor: AppColors.easyTier,
          child: Column(
            children: [
              const Text(
                'المسألة الحسابية:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                challenge.expression,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'اختر الإجابة الصحيحة:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          physics: const NeverScrollableScrollPhysics(),
          children: challenge.options.map((opt) {
            return ElevatedButton(
              onPressed: () {
                if (opt == challenge.answer) {
                  onGameWon();
                } else {
                  onGameLost();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkCard,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                '$opt',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
