import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';

abstract class BaseMiniGame {
  final String id;
  final String title;
  final String description;
  final String rules;
  final MiniGameDifficulty difficulty;
  final int timeLimitSeconds;
  final int rewardAmount;
  final int penaltyAmount;
  final IconData icon;

  const BaseMiniGame({
    required this.id,
    required this.title,
    required this.description,
    required this.rules,
    required this.difficulty,
    required this.timeLimitSeconds,
    required this.rewardAmount,
    required this.penaltyAmount,
    required this.icon,
  });

  /// Initializes a new randomized challenge instance
  void generateNewChallenge();

  /// Builds the interactive challenge UI for this game
  Widget buildChallengeWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  });
}
