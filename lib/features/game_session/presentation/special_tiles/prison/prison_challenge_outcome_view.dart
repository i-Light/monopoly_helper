import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/core/widgets/scale_to_fit.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/end_turn_button.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// The results-page content for a resolved prison escape attempt. No
/// real [CityModel] is involved here, so unlike every other results-page
/// variant this is fully self-contained — no title row, city image, or
/// owner-badge slot from the normal shell.
class PrisonChallengeOutcomeView extends StatelessWidget {
  const PrisonChallengeOutcomeView({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final won = controller.challengeOutcome == ChallengeOutcome.won;

    return Padding(
      padding: EdgeInsets.all(16 * scale),
      child: SizedBox.expand(
        child: ScaleToFit(
          referenceWidth: 380,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                won ? Icons.lock_open : Icons.lock,
                size: 72 * scale,
                color: won ? AppColors.success : AppColors.jailRed,
              ),
              SizedBox(height: 14 * scale),
              Text(
                won
                    ? AppStrings.prisonEscapeWonHeadline
                    : AppStrings.prisonEscapeLostHeadline,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 18 * scale),
              EndTurnButton(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
