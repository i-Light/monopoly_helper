import 'package:flutter/material.dart';
import '../core/base_mini_game.dart';
import '../core/mini_game_difficulty.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/datasets/common_letter_data.dart';

class CommonLetterFinderGame extends BaseMiniGame {
  CommonLetterItem? _currentChallenge;

  CommonLetterFinderGame()
      : super(
          id: 'common_letter_finder',
          title: AppStrings.gameCommonLetterTitle,
          description: AppStrings.gameCommonLetterDesc,
          rules: 'ابحث عن الحرف المشترك الوحيد المتواجد في جميع الكلمات الأربع المعروضة!',
          difficulty: MiniGameDifficulty.medium,
          timeLimitSeconds: GameConstants.commonLetterTime,
          rewardAmount: GameConstants.mediumReward,
          penaltyAmount: GameConstants.mediumPenalty,
          icon: Icons.spellcheck,
        );

  @override
  void generateNewChallenge() {
    _currentChallenge = CommonLetterData.getRandom();
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
          color: AppColors.mediumTier.withOpacity(0.12),
          borderColor: AppColors.mediumTier,
          child: Column(
            children: [
              const Text(
                'الكلمات المشتركة في حرف واحد:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: item.words
                    .map((w) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.darkCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.mediumTier.withOpacity(0.5)),
                          ),
                          child: Text(
                            w,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'اختر الحرف المشترك:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: item.options.map((letter) {
            return SizedBox(
              width: 60,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (letter == item.commonLetter) {
                    onGameWon();
                  } else {
                    onGameLost();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkCard,
                  side: const BorderSide(color: AppColors.mediumTier, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  letter,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
