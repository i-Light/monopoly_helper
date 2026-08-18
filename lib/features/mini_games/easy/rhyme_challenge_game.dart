import 'package:flutter/material.dart';
import '../core/base_mini_game.dart';
import '../core/mini_game_difficulty.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/datasets/rhyme_data.dart';

class RhymeChallengeGame extends BaseMiniGame {
  RhymeItem? _currentChallenge;

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

  @override
  void generateNewChallenge() {
    _currentChallenge = RhymeData.getRandom();
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
          color: AppColors.easyTier.withOpacity(0.12),
          borderColor: AppColors.easyTier,
          child: Column(
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
        ),
        const SizedBox(height: 14),
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
                            backgroundColor: AppColors.easyTier.withOpacity(0.15),
                          ))
                      .toList(),
                ),
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
