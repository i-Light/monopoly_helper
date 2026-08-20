import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// The action row pinned under the challenge content.
///
/// Reacts to [ChallengeOutcome]:
///   * undetermined -> only "new challenge" shows.
///   * won -> "new challenge" + a disabled "don't move" + an enabled
///     "تم، التالي" (confirm & continue) button.
///   * lost -> "new challenge" + an enabled "don't move" + an enabled
///     "pay to move" button (which asks for confirmation first).
class BottomActionToolbar extends StatelessWidget {
  const BottomActionToolbar({
    super.key,
    required this.outcome,
    required this.penaltyAmount,
    required this.onNewChallenge,
    required this.onDontMove,
    required this.onConfirmWon,
    required this.onRequestPay,
  });

  final ChallengeOutcome outcome;
  final int penaltyAmount;
  final VoidCallback onNewChallenge;
  final VoidCallback onDontMove;
  final VoidCallback onConfirmWon;
  final VoidCallback onRequestPay;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final concluded = outcome != ChallengeOutcome.undetermined;
    final won = outcome == ChallengeOutcome.won;

    return Wrap(
      spacing: 10 * scale,
      runSpacing: 8 * scale,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (concluded)
          OutlinedButton.icon(
            onPressed: won ? null : onDontMove,
            icon: Icon(Icons.block, size: 18 * scale),
            label: Text(AppStrings.dontMove, style: TextStyle(fontSize: 13 * scale)),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 10 * scale),
            ),
          ),
        if (concluded)
          ElevatedButton.icon(
            onPressed: won ? onConfirmWon : onRequestPay,
            icon: Icon(won ? Icons.check_circle : Icons.payments, size: 18 * scale),
            label: Text(
              won
                  ? AppStrings.confirmAndContinue
                  : '${AppStrings.payToMovePrefix} $penaltyAmount${AppStrings.currency}+ ${AppStrings.payToMoveSuffix}',
              style: TextStyle(fontSize: 13 * scale),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: won ? AppColors.success : AppColors.warning,
              padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 10 * scale),
            ),
          ),
        OutlinedButton.icon(
          onPressed: onNewChallenge,
          icon: Icon(Icons.refresh, size: 18 * scale),
          label: Text(AppStrings.newChallenge, style: TextStyle(fontSize: 13 * scale)),
          style: OutlinedButton.styleFrom(
            // Fixed minimum size so this button doesn't visibly grow or
            // shrink as the Wrap reflows around the (variable-length)
            // won/lost button next to it.
            minimumSize: Size(140 * scale, 44 * scale),
            padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 10 * scale),
          ),
        ),
      ],
    );
  }
}
