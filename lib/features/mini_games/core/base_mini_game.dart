import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';

/// Contract every mini-game implements.
///
/// A mini-game's UI is split into two parts so the games page can lay the
/// timer out next to just the "question" and keep the interactive part
/// (answer buttons, self-judge buttons, ...) underneath it:
///   * [buildQueryWidget] — the prompt: the letter, the word, the math
///     expression, the question... whatever the player needs to read to
///     attempt the challenge. Sits next to the timer at the top of the
///     games page.
///   * [buildInteractionWidget] — everything the player taps to answer or
///     to self-judge the result (multiple-choice buttons, a "answered
///     correctly / didn't" pair, etc). Sits below, in its own row.
///
/// Individual mini-games' wording, rules and scoring logic are untouched
/// from the previous version of the app — only how their widget was split
/// in two changed.
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

  /// Initializes a new randomized challenge instance.
  void generateNewChallenge();

  /// Builds the "question" part of the challenge (paired with the timer).
  Widget buildQueryWidget(BuildContext context);

  /// Builds the interactive part of the challenge (answer/self-judge
  /// controls), placed below the timer + query row.
  Widget buildInteractionWidget(
    BuildContext context, {
    required VoidCallback onGameWon,
    required VoidCallback onGameLost,
  });
}
