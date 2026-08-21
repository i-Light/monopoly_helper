import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/mini_games/rhyme_data.dart';

class RhymeChallengeGame extends BaseMiniGame {
  RhymeChallengeGame()
      : super(
          id: 'rhyme_challenge',
          title: AppStrings.gameRhymeChallengeTitle,
          description: AppStrings.gameRhymeChallengeDesc,
          rules: 'اذكر 3 كلمات على الأقل لها نفس القافية والوزن مع الكلمة المحددة.',
          difficulty: MiniGameDifficulty.easy,
          timeLimitSeconds: GameConstants.rhymeTime,
          rewardAmount: GameConstants.easyReward,
          penaltyAmount: GameConstants.easyPenalty,
          icon: Icons.music_note,
        );

  RhymeItem? _currentChallenge;

  @override
  void generateNewChallenge() {
    _currentChallenge = RhymeData.getRandom();
  }

  @override
  Widget buildQueryWidget(BuildContext context) {
    final item = _currentChallenge ??= RhymeData.getRandom();

    return CustomCard(
      color: AppColors.easyTier.withValues(alpha: 0.12),
      borderColor: AppColors.easyTier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'الكلمة المطلوب إيجاد قوافي لها:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '« ${item.baseWord} »',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'المطلوب: اذكر ${item.requiredCount} كلمات قافية',
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
    final item = _currentChallenge ??= RhymeData.getRandom();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          child: ExpansionTile(
            title: const Text(
              'أمثلة مقترحة للقوافي (للحَكَم)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.validRhymes
                      .map((rhyme) => Chip(
                            label: Text(rhyme),
                            backgroundColor: AppColors.easyTier.withValues(alpha: 0.15),
                          ))
                      .toList(),
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
              label: const Text('ذكر 3 قوافي صحيحة'),
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
