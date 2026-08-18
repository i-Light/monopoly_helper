import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/datasets/stroop_effect_data.dart';

class StroopEffectGame extends BaseMiniGame {
  StroopItem? _currentChallenge;

  StroopEffectGame()
      : super(
          id: 'stroop_effect',
          title: AppStrings.gameStroopEffectTitle,
          description: AppStrings.gameStroopEffectDesc,
          rules: 'ركّز! اختر اسم لون الحبر المكتوب به الكلمة، وتجاهل المعنى النصي للكلمة!',
          difficulty: MiniGameDifficulty.hard,
          timeLimitSeconds: GameConstants.stroopEffectTime,
          rewardAmount: GameConstants.hardReward,
          penaltyAmount: GameConstants.hardPenalty,
          icon: Icons.color_lens,
        );

  @override
  void generateNewChallenge() {
    _currentChallenge = StroopEffectData.generateChallenge();
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
          child: Column(
            children: [
              const Text(
                'ما هو لون الحبر (وليس الكلمة)؟',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  item.textWord,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: item.displayColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          physics: const NeverScrollableScrollPhysics(),
          children: item.colorOptions.map((cName) {
            return ElevatedButton(
              onPressed: () {
                if (cName == item.colorNameArabic) {
                  onGameWon();
                } else {
                  onGameLost();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkCard,
                side: const BorderSide(color: AppColors.hardTier, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                cName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
