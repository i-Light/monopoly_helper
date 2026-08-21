import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Replaces [BottomActionToolbar] on the challenge page when the current
/// challenge is a prison escape attempt: there's no "pay to move anyway"
/// or "don't move" choice here, just a single continue button once the
/// outcome is known — styled like the normal toolbar's own won/lost
/// button so the "button shape is shared" rule holds here too.
class PrisonChallengeToolbar extends StatelessWidget {
  const PrisonChallengeToolbar(
      {super.key, required this.outcome, required this.onContinue});

  final ChallengeOutcome outcome;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    if (outcome == ChallengeOutcome.undetermined) {
      return const SizedBox.shrink();
    }
    final won = outcome == ChallengeOutcome.won;

    return ElevatedButton.icon(
      onPressed: onContinue,
      icon: Icon(won ? Icons.check_circle : Icons.arrow_forward,
          size: 18 * scale),
      label: Text(AppStrings.confirmAndContinue,
          style: TextStyle(fontSize: 13 * scale)),
      style: ElevatedButton.styleFrom(
        backgroundColor: won ? AppColors.success : AppColors.warning,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 10 * scale),
      ),
    );
  }
}
