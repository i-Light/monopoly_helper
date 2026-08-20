import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/steps_grid.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Stage 1 of the main frame: the player picks how many steps they want
/// to play. Deliberately has nothing scrollable — the explanatory line
/// and the 3x3 grid are laid out with [Expanded]/[Flexible] so they
/// always fit inside whatever height is available.
class MovesSelectionPage extends StatelessWidget {
  const MovesSelectionPage({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return Padding(
      padding: EdgeInsets.all(16 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.movesSelectionPrompt,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14 * scale, height: 1.5, color: Colors.grey.shade300),
          ),
          SizedBox(height: 18 * scale),
          Expanded(
            child: StepsGrid(onStepsSelected: controller.selectSteps),
          ),
        ],
      ),
    );
  }
}
