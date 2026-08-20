import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/game_session/presentation/pages/challenge_page.dart';
import 'package:monopoly_helper/features/game_session/presentation/pages/moves_selection_page.dart';
import 'package:monopoly_helper/features/game_session/presentation/pages/results_page.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// The "main frame" from the brief: an infinite loop of three pages —
/// moves selection -> challenge -> results -> (next player's) moves
/// selection -> ... — all driven by [GameSessionController.stage].
class GameSessionFrame extends StatelessWidget {
  const GameSessionFrame({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: KeyedSubtree(
        key: ValueKey(controller.stage),
        child: switch (controller.stage) {
          TurnStage.movesSelection => MovesSelectionPage(controller: controller),
          TurnStage.challenge => ChallengePage(controller: controller),
          TurnStage.results => ResultsPage(controller: controller),
        },
      ),
    );
  }
}
