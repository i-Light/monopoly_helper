import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/common_letter_data.dart';

class CommonLetterFinderGame extends BaseMiniGame {
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

  CommonLetterItem? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = CommonLetterData.getRandom();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    final item = _currentChallenge ??= CommonLetterData.getRandom();

    return CustomCard(
      color: AppColors.mediumTier.withValues(alpha: 0.12),
      borderColor: AppColors.mediumTier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                        border: Border.all(color: AppColors.mediumTier.withValues(alpha: 0.5)),
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
    );
  }

  @override
  Widget buildInteractionWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  }) {
    final item = _currentChallenge ??= CommonLetterData.getRandom();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
