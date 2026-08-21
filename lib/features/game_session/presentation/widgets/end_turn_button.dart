import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// The "أنهى الدور" button shared by every results-page variant that
/// doesn't already end the turn as a side effect of its own action (the
/// normal-city buy flow when unowned, every special tile's passthrough/
/// club/prison-outcome content).
class EndTurnButton extends StatelessWidget {
  const EndTurnButton({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: controller.finishTurn,
      icon: const Icon(Icons.flag_circle, size: 26),
      label: const Text(AppStrings.endTurn,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 62),
      ),
    );
  }
}
