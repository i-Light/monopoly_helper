import 'package:flutter/material.dart';
import '../core/base_mini_game.dart';
import '../core/mini_game_difficulty.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/datasets/word_chain_data.dart';

class LastLetterWordChainGame extends BaseMiniGame {
  WordChainItem? _currentChallenge;

  LastLetterWordChainGame()
      : super(
          id: 'last_letter_word_chain',
          title: AppStrings.gameWordChainTitle,
          description: AppStrings.gameWordChainDesc,
          rules: 'كوّن سلسلة من 4 كلمات متتالية حيث تبدأ كل كلمة بالحرف الأخير من الكلمة التي تسبقها.',
          difficulty: MiniGameDifficulty.medium,
          timeLimitSeconds: GameConstants.wordChainTime,
          rewardAmount: GameConstants.mediumReward,
          penaltyAmount: GameConstants.mediumPenalty,
          icon: Icons.link,
        );

  @override
  void generateNewChallenge() {
    _currentChallenge = WordChainData.getRandom();
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
                'الكلمة الابتدائية للسلسلة:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.mediumTier,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.startingWord,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'المطلوب تكوين ${item.requiredChainLength} كلمات متسلسلة بالحرف الأخير',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('مثال للتوضيح (للحَكَم):', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                item.exampleChain,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: onGameWon,
              icon: const Icon(Icons.check),
              label: const Text('أكمل السلسلة بنجاح'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
            ElevatedButton.icon(
              onPressed: onGameLost,
              icon: const Icon(Icons.close),
              label: const Text('إخفاق'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            ),
          ],
        ),
      ],
    );
  }
}
