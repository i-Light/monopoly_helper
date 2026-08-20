import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/word_ban_data.dart';

class WordBanGame extends BaseMiniGame {
  WordBanGame()
      : super(
          id: 'word_ban',
          title: AppStrings.gameWordBanTitle,
          description: AppStrings.gameWordBanDesc,
          rules: 'اشرح الكلمة الرئيسية لزملائك ليخمّنوها دون نطق الكلمة نفسها أو أي من الكلمات المحظورة الخمس!',
          difficulty: MiniGameDifficulty.medium,
          timeLimitSeconds: GameConstants.wordBanTime,
          rewardAmount: GameConstants.mediumReward,
          penaltyAmount: GameConstants.mediumPenalty,
          icon: Icons.block,
        );

  WordBanCard? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = WordBanData.getRandom();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    final card = _currentChallenge ??= WordBanData.getRandom();

    return CustomCard(
      color: AppColors.mediumTier.withValues(alpha: 0.15),
      borderColor: AppColors.mediumTier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'الكلمة المطلوب شرحها (Target):',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            card.targetWord,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.cashGold,
            ),
          ),
          Text(
            'التصنيف: ${card.category}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
    final card = _currentChallenge ??= WordBanData.getRandom();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          borderColor: AppColors.error.withValues(alpha: 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.warning_amber, color: AppColors.error, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'الكلمات المحظورة تماماً (ممنوع نطقها):',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: card.forbiddenWords
                    .map((w) => Chip(
                          label: Text(
                            w,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          backgroundColor: AppColors.error.withValues(alpha: 0.25),
                          side: const BorderSide(color: AppColors.error, width: 1),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onGameWon,
              icon: const Icon(Icons.check),
              label: const Text('خمنوها بنجاح'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
            ElevatedButton.icon(
              onPressed: onGameLost,
              icon: const Icon(Icons.close),
              label: const Text('نطق محظور / إخفاق'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            ),
          ],
        ),
      ],
    );
  }
}
