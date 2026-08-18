import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/dice_widget.dart';
import '../../../../core/widgets/player_avatar.dart';
import '../../../player_management/state/player_provider.dart';
import '../../../mini_games/core/mini_game_manager.dart';
import '../../../mini_games/presentation/mini_game_runner_screen.dart';
import 'widgets/quick_actions_panel.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final players = playerProvider.players;
    final leader = playerProvider.leadingPlayer;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'إعادة ضبط اللعبة',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('إعادة ضبط اللعبة'),
                  content: const Text('هل أنت متأكد من رغبتك في إعادة ضبط جميع اللاعبين والأرصدة؟'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () {
                        playerProvider.resetGame();
                        Navigator.pop(ctx);
                      },
                      child: const Text('إعادة ضبط'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Overview Banner
            CustomCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F381E), Color(0xFF1B5E20)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cashGold.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: AppColors.cashGold, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.totalCashInGame,
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          '${playerProvider.totalCashInGame} \$',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.cashGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (leader != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'المتصدر 👑',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          leader.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: leader.color,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Dice Roller Section
            CustomCard(
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.casino, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        AppStrings.diceRoller,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DiceWidget(
                    die1: playerProvider.die1,
                    die2: playerProvider.die2,
                    isRolling: playerProvider.isRolling,
                    isDouble: playerProvider.isDouble,
                    consecutiveDoubles: playerProvider.consecutiveDoubles,
                    onRoll: () => playerProvider.rollDice(),
                  ),
                  if (playerProvider.diceAlertMessage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Text(
                        playerProvider.diceAlertMessage!,
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Quick Banking Actions
            const QuickActionsPanel(),
            const SizedBox(height: 14),

            // Random Mini Game Banner
            CustomCard(
              color: AppColors.primaryDark.withOpacity(0.2),
              borderColor: AppColors.primary,
              onTap: () {
                if (playerProvider.activePlayers.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إضافة لاعبين أولاً')),
                  );
                  return;
                }
                final game = MiniGameManager().getRandomGame();
                final challenger = playerProvider.currentTurnPlayer ?? playerProvider.activePlayers.first;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MiniGameRunnerScreen(
                      game: game,
                      challenger: challenger,
                    ),
                  ),
                );
              },
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.sports_esports, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تحدي لعبة مصغرة فورية! 🎲',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'اختر لعبة عشوائية للاعب الحالي لتحصيل المكافأة أو العقوبة',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppColors.primaryLight, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Active Players Quick Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.activePlayers,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${players.length} لاعبين',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...players.map((p) => CustomCard(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      PlayerAvatar(
                        name: p.name,
                        color: p.color,
                        isInJail: p.isInJail,
                        isBankrupt: p.isBankrupt,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                if (p.isInJail) ...[
                                  const SizedBox(width: 6),
                                  const Chip(
                                    label: Text('في السجن', style: TextStyle(fontSize: 10, color: Colors.white)),
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                                if (p.isBankrupt) ...[
                                  const SizedBox(width: 6),
                                  const Chip(
                                    label: Text('مفلس', style: TextStyle(fontSize: 10, color: Colors.white)),
                                    backgroundColor: Colors.grey,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              'ألعاب: ${p.totalMiniGamesWon} فوز / ${p.totalMiniGamesPlayed}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${p.balance} \$',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.cashGold,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
