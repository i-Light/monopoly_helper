import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/core/widgets/scale_to_fit.dart';
import 'package:monopoly_helper/data/datasets/cities_data.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/action_tile_button.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/city_image_frame.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Shown instead of [MovesSelectionPage] for a jailed player's turn: try
/// a forced-hard escape challenge, or pay bail to guarantee release next
/// turn. Both choices end the turn on their own, so there's no separate
/// end-turn button here.
class PrisonChoicePage extends StatelessWidget {
  const PrisonChoicePage({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final prisonCity = CitiesData.byIndex(CitiesData.prisonIndex);
    final canAffordBail =
        controller.activePlayer.balance >= GameConstants.jailBailCost;

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
              const Text(
                AppStrings.prisonChoiceHeadline,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 14 * scale),
              CityImageFrame(city: prisonCity),
              SizedBox(height: 18 * scale),
              ActionTileButton(
                icon: Icons.quiz,
                label: AppStrings.prisonAttemptEscapeLabel,
                isOwned: false,
                disabled: false,
                onTap: controller.attemptPrisonEscape,
              ),
              SizedBox(height: 10 * scale),
              ActionTileButton(
                icon: Icons.payments,
                label:
                    '${AppStrings.prisonPayBailLabel} (${GameConstants.jailBailCost}${AppStrings.currency})',
                isOwned: false,
                disabled: !canAffordBail,
                onTap: controller.payPrisonBail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
