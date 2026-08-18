import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/sound_helper.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/difficulty_badge.dart';
import '../../../../core/widgets/game_timer_widget.dart';
import '../../../../core/widgets/player_avatar.dart';
import '../../../../data/models/player_model.dart';
import '../../../player_management/state/player_provider.dart';
import '../../core/base_mini_game.dart';
import '../../core/mini_game_session.dart';

class MiniGameRunnerScreen extends StatefulWidget {
  final BaseMiniGame game;
  final PlayerModel challenger;

  const MiniGameRunnerScreen({
    super.key,
    required this.game,
    required this.challenger,
  });

  @override
  State<MiniGameRunnerScreen> createState() => _MiniGameRunnerScreenState();
}

class _MiniGameRunnerScreenState extends State<MiniGameRunnerScreen> {
  late MiniGameSession _session;

  @override
  void initState() {
    super.initState();
    _session = MiniGameSession(
      game: widget.game,
      challenger: widget.challenger,
    );
    _session.start();
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  void _handleGameWon() {
    _session.markWon();
    SoundHelper.playSuccess();
    context.read<PlayerProvider>().resolveMiniGameResult(
          playerId: widget.challenger.id,
          gameTitle: widget.game.title,
          isWon: true,
          rewardAmount: widget.game.rewardAmount,
          penaltyAmount: widget.game.penaltyAmount,
        );
    _showResultDialog(isWon: true);
  }

  void _handleGameLost() {
    _session.markLost();
    SoundHelper.playFail();
    context.read<PlayerProvider>().resolveMiniGameResult(
          playerId: widget.challenger.id,
          gameTitle: widget.game.title,
          isWon: false,
          rewardAmount: widget.game.rewardAmount,
          penaltyAmount: widget.game.penaltyAmount,
        );
    _showResultDialog(isWon: false);
  }

  void _showResultDialog({required bool isWon}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isWon ? Icons.celebration : Icons.sentiment_very_dissatisfied,
              color: isWon ? AppColors.success : AppColors.error,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(isWon ? 'مبروك الفوز! 🎉' : 'حظ أوفر في المرة القادمة! ❌'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اللاعب: ${widget.challenger.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('اللعبة: ${widget.game.title}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isWon ? AppColors.success : AppColors.error).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isWon ? AppColors.success : AppColors.error),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isWon ? 'المكافأة المضافة:' : 'العقوبة المخصومة:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isWon ? '+${widget.game.rewardAmount} \$' : '-${widget.game.penaltyAmount} \$',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isWon ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Exit runner screen
            },
            child: const Text('العودة للعبة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _session,
      builder: (context, _) {
        if (_session.state == GamePlayState.timeOut) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleGameLost();
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.game.title),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DifficultyBadge(difficulty: widget.game.difficulty),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header: Challenger & Timer
                CustomCard(
                  child: Row(
                    children: [
                      PlayerAvatar(
                        name: widget.challenger.name,
                        color: widget.challenger.color,
                        size: 52,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('المتحدي الحالي:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(
                              widget.challenger.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'رصيده: ${widget.challenger.balance} \$',
                              style: const TextStyle(fontSize: 13, color: AppColors.cashGold, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      GameTimerWidget(
                        remainingSeconds: _session.secondsLeft,
                        totalSeconds: _session.totalSeconds,
                        isRunning: _session.isRunning,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Rules Card
                CustomCard(
                  color: AppColors.darkSurface,
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.game.rules,
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Dynamic Game Widget
                widget.game.buildChallengeWidget(
                  context,
                  onGameWon: _handleGameWon,
                  onGameLost: _handleGameLost,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
