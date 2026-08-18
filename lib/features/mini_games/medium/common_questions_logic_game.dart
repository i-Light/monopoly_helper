import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/trivia_questions_data.dart';

class CommonQuestionsLogicGame extends BaseMiniGame {
  TriviaQuestion? _currentChallenge;

  CommonQuestionsLogicGame()
      : super(
          id: 'common_questions_logic',
          title: AppStrings.gameTriviaLogicTitle,
          description: AppStrings.gameTriviaLogicDesc,
          rules: 'أجب عن سؤال الثقافة العامة أو المنطق باختيار الإجابة الصحيحة من بين الخيارات.',
          difficulty: MiniGameDifficulty.medium,
          timeLimitSeconds: GameConstants.triviaTime,
          rewardAmount: GameConstants.mediumReward,
          penaltyAmount: GameConstants.mediumPenalty,
          icon: Icons.psychology,
        );

  @override
  void generateNewChallenge() {
    _currentChallenge = TriviaQuestionsData.getRandom();
  }

  @override
  Widget buildChallengeWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  }) {
    if (_currentChallenge == null) generateNewChallenge();
    final question = _currentChallenge!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          color: AppColors.mediumTier.withOpacity(0.12),
          borderColor: AppColors.mediumTier,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.mediumTier.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      question.category,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.mediumTier),
                    ),
                  ),
                  const Icon(Icons.help_outline, color: AppColors.mediumTier, size: 20),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                question.question,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(question.options.length, (idx) {
          final opt = question.options[idx];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ElevatedButton(
              onPressed: () {
                if (idx == question.correctIndex) {
                  onGameWon();
                } else {
                  onGameLost();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkCard,
                foregroundColor: Colors.white,
                side: const BorderSide(color: AppColors.darkBorder, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.centerRight,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: AppColors.mediumTier.withOpacity(0.2),
                    child: Text(
                      '${idx + 1}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.mediumTier),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      opt,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
