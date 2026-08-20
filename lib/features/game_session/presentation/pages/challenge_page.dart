import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/core/widgets/difficulty_badge.dart';
import 'package:monopoly_helper/core/widgets/game_timer_widget.dart';
import 'package:monopoly_helper/core/widgets/scale_to_fit.dart';
import 'package:monopoly_helper/features/challenge_picker/presentation/show_challenge_picker.dart';
import 'package:monopoly_helper/features/game_session/presentation/dialogs/pay_confirmation_dialog.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/bottom_action_toolbar.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/rules_banner.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Stage 2 of the main frame: the mini-game challenge itself ("Games
/// screen" in the brief).
///
/// Layout, top to bottom:
///   1. game icon + title + difficulty badge
///   2. the expandable rules banner
///   3. timer + the game's "query" widget in a row (desktop) or stacked
///      (phone), then the game's interactive answer widgets below —
///      the whole block is wrapped in [ScaleToFit] so it can never
///      overflow or need to scroll, no matter how much a given mini-game
///      needs to show.
///   4. the bottom action toolbar.
class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key, required this.controller});

  final GameSessionController controller;

  Future<void> _openPicker(BuildContext context) async {
    final game = await showChallengePicker(
      context,
      initialDifficulty: controller.currentGame?.difficulty,
    );
    if (game != null) controller.pickChallengeManually(game);
  }

  Future<void> _requestPay(BuildContext context) async {
    final amount = controller.currentGame?.penaltyAmount ?? 0;
    final confirmed = await showPayConfirmationDialog(context, amount: amount);
    if (confirmed) controller.confirmPaidMove();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final game = controller.currentGame;
    if (game == null) return const SizedBox.shrink();

    final isDesktop = context.isDesktop;

    return Padding(
      padding: EdgeInsets.all(14 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8 * scale),
                decoration: BoxDecoration(
                  color: game.difficulty.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(game.icon, color: game.difficulty.color, size: 22 * scale),
              ),
              SizedBox(width: 10 * scale),
              Expanded(
                child: Text(
                  game.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 8 * scale),
              DifficultyBadge(difficulty: game.difficulty),
            ],
          ),
          SizedBox(height: 10 * scale),
          RulesBanner(rules: game.rules),
          SizedBox(height: 10 * scale),
          Expanded(
            child: ScaleToFit(
              referenceWidth: isDesktop ? 680 : 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TimerBlock(controller: controller),
                            const SizedBox(width: 20),
                            Expanded(child: game.buildQueryWidget(context)),
                          ],
                        )
                      : Column(
                          children: [
                            _TimerBlock(controller: controller),
                            const SizedBox(height: 14),
                            game.buildQueryWidget(context),
                          ],
                        ),
                  const SizedBox(height: 16),
                  game.buildInteractionWidget(
                    context,
                    onGameWon: controller.markChallengeWon,
                    onGameLost: controller.markChallengeLost,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10 * scale),
          BottomActionToolbar(
            outcome: controller.challengeOutcome,
            penaltyAmount: game.penaltyAmount,
            onNewChallenge: () => _openPicker(context),
            onDontMove: controller.chooseDontMove,
            onConfirmWon: controller.confirmWonMove,
            onRequestPay: () => _requestPay(context),
          ),
        ],
      ),
    );
  }
}

class _TimerBlock extends StatelessWidget {
  const _TimerBlock({required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GameTimerWidget(
          remainingSeconds: controller.secondsLeft,
          totalSeconds: controller.totalSeconds,
          isRunning: controller.isTimerRunning,
          size: 84,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!controller.isTimerRunning)
              IconButton(
                icon: const Icon(Icons.play_arrow, color: AppColors.success, size: 22),
                onPressed: controller.startTimer,
              )
            else
              IconButton(
                icon: const Icon(Icons.pause, color: AppColors.warning, size: 22),
                onPressed: controller.pauseTimer,
              ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.grey, size: 20),
              onPressed: controller.resetTimer,
            ),
          ],
        ),
      ],
    );
  }
}
