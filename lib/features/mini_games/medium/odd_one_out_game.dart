import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/odd_one_out_data.dart';

class OddOneOutGame extends BaseMiniGame {
  OddOneOutGame()
      : super(
          id: 'odd_one_out',
          title: AppStrings.gameOddOneOutTitle,
          description: AppStrings.gameOddOneOutDesc,
          rules: 'حدد الكلمة الشاذة التي لا تنتمي لنفس المجموعة من بين الكلمات الأربع.',
          difficulty: MiniGameDifficulty.medium,
          timeLimitSeconds: GameConstants.oddOneOutTime,
          rewardAmount: GameConstants.mediumReward,
          penaltyAmount: GameConstants.mediumPenalty,
          icon: Icons.find_in_page,
        );

  OddOneOutItem? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = OddOneOutData.getRandom();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    final item = _currentChallenge ??= OddOneOutData.getRandom();

    return CustomCard(
      color: AppColors.mediumTier.withValues(alpha: 0.12),
      borderColor: AppColors.mediumTier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ما هي الكلمة الشاذة أو المختلفة؟',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'المجال العام: ${item.groupCategory}',
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
    final item = _currentChallenge ??= OddOneOutData.getRandom();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.3,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(item.words.length, (idx) {
        final word = item.words[idx];
        return ElevatedButton(
          onPressed: () {
            if (idx == item.oddIndex) {
              onGameWon();
            } else {
              onGameLost();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkCard,
            side: const BorderSide(color: AppColors.mediumTier, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            word,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    );
  }
}
