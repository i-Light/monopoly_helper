import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/reverse_words_data.dart';

class ShortReverseWordGame extends BaseMiniGame {
  ShortReverseWordGame()
      : super(
          id: 'short_reverse_word',
          title: AppStrings.gameShortReverseWordTitle,
          description: AppStrings.gameShortReverseWordDesc,
          rules: 'اقرأ أو تهجأ الكلمة المعروضة حرفاً بحرف من اليسار إلى اليمين (بالعكس) دون أخطاء!',
          difficulty: MiniGameDifficulty.easy,
          timeLimitSeconds: GameConstants.shortReverseWordTime,
          rewardAmount: GameConstants.easyReward,
          penaltyAmount: GameConstants.easyPenalty,
          icon: Icons.swap_horiz,
        );

  ReverseWordItem? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = ReverseWordsData.getRandom();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    final item = _currentChallenge ??= ReverseWordsData.getRandom();

    return CustomCard(
      color: AppColors.easyTier.withValues(alpha: 0.12),
      borderColor: AppColors.easyTier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'الكلمة الأصلية:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            item.word,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryLight,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'تلميح: ${item.hint}',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
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
    final item = _currentChallenge ??= ReverseWordsData.getRandom();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          child: Column(
            children: [
              const Text(
                'الإجابة الصحيحة بالمعكوس (للحكم):',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                item.reversed,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cashGold,
                  letterSpacing: 3.0,
                ),
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
              label: const Text('نطقها صحيحة'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
            ElevatedButton.icon(
              onPressed: onGameLost,
              icon: const Icon(Icons.close),
              label: const Text('أخطأ'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            ),
          ],
        ),
      ],
    );
  }
}
