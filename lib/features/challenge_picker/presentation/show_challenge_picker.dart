import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/challenge_picker/presentation/challenge_picker_panel.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';

/// Opens [ChallengePickerPanel] as a modal bottom sheet that adapts its
/// width/height for phones vs. wide desktop windows, and returns the
/// [BaseMiniGame] the player picked (or null if they dismissed it).
Future<BaseMiniGame?> showChallengePicker(
  BuildContext context, {
  MiniGameDifficulty? initialDifficulty,
}) {
  final isDesktop = context.isDesktop;

  return showModalBottomSheet<BaseMiniGame>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.95;
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 460 : double.infinity,
            maxHeight: maxHeight,
            minHeight: maxHeight,
          ),
          child: Container(
            margin: isDesktop ? const EdgeInsets.only(bottom: 24) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(sheetContext).cardColor,
              borderRadius: BorderRadius.vertical(top: const Radius.circular(20)),
              border: Border.all(color: Theme.of(sheetContext).dividerColor),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ),
                  Expanded(
                    child: ChallengePickerPanel(
                      initialDifficulty: initialDifficulty,
                      onGameSelected: (game) => Navigator.of(sheetContext).pop(game),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
