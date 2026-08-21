import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/action_tile_button.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Shown alongside the buy-from-owner/pay-rent buttons on a normal city
/// owned by someone else, whenever [GameSessionController.canChooseArrest]
/// — lets the active player opt out of paying and go to prison instead.
/// Tapping it ends the turn immediately.
class PrisonArrestButton extends StatelessWidget {
  const PrisonArrestButton({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    return ActionTileButton(
      icon: Icons.local_police,
      label: AppStrings.prisonArrestButtonLabel,
      isOwned: false,
      disabled: false,
      onTap: controller.arrestActivePlayerForDebt,
    );
  }
}
