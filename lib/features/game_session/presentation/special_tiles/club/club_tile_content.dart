import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/action_tile_button.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/end_turn_button.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Results-page content for the club tile: a subscribe button (up to
/// [GameConstants.clubSubscriberCapacity] independent subscribers, no
/// rent, no garage/market), or a status note once the active player is
/// already a member or the club is full — plus the shared end-turn
/// button, since subscribing doesn't end the turn by itself.
class ClubTileContent extends StatelessWidget {
  const ClubTileContent({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final city = controller.relevantCity;

    Widget statusNote(String text) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10 * scale),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16 * scale, color: Colors.grey),
          ),
        );

    final Widget middle;
    if (controller.activePlayerIsClubSubscriber) {
      middle = statusNote(AppStrings.clubAlreadyMember);
    } else if (!controller.clubHasOpenSlot) {
      middle = statusNote(AppStrings.clubFull);
    } else {
      middle = ActionTileButton(
        icon: Icons.groups,
        label:
            '${AppStrings.clubSubscribeLabel} (${city.basePrice}${AppStrings.currency})',
        isOwned: false,
        disabled: !controller.canSubscribeToClub,
        onTap: controller.subscribeToClub,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        middle,
        SizedBox(height: 10 * scale),
        EndTurnButton(controller: controller),
      ],
    );
  }
}
