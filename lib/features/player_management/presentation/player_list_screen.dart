import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/core/widgets/player_avatar.dart';
import 'package:monopoly_helper/features/player_management/state/player_provider.dart';
import 'package:monopoly_helper/features/player_management/presentation/dialogs/add_player_dialog.dart';
import 'package:monopoly_helper/features/player_management/presentation/dialogs/transfer_money_dialog.dart';
import 'package:monopoly_helper/features/player_management/presentation/dialogs/quick_amount_dialog.dart';

class PlayerListScreen extends StatelessWidget {
  const PlayerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final players = playerProvider.players;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navPlayers),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: AppStrings.transferMoney,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const TransferMoneyDialog(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddPlayerDialog(),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add),
        label: const Text(AppStrings.addPlayer),
      ),
      body: players.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('لا يوجد لاعبون مسجلون حالياً', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const AddPlayerDialog(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(AppStrings.addPlayer),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          PlayerAvatar(
                            name: player.name,
                            color: player.color,
                            size: 50,
                            isInJail: player.isInJail,
                            isBankrupt: player.isBankrupt,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'صافي الثروة: ${player.netWorth} £',
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${player.balance} £',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.cashGold,
                                ),
                              ),
                              if (player.isInJail)
                                const Text('في السجن 🚨', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                              if (player.isBankrupt)
                                const Text('مفلس ❌', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      // Action Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.add, size: 16, color: AppColors.success),
                            label: const Text('+ استلام'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => QuickAmountDialog(
                                  title: 'إيداع / استلام من البنك',
                                  playerName: player.name,
                                  onConfirm: (amt) => playerProvider.receiveFromBank(player.id, amt),
                                ),
                              );
                            },
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.remove, size: 16, color: AppColors.error),
                            label: const Text('- خصم'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => QuickAmountDialog(
                                  title: 'خصم / دفع للبنك',
                                  playerName: player.name,
                                  onConfirm: (amt) => playerProvider.payToBank(player.id, amt),
                                ),
                              );
                            },
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.arrow_forward, size: 16, color: AppColors.boardGreen),
                            label: const Text('GO (+200£)'),
                            onPressed: () => playerProvider.passGo(player.id),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.swap_horiz, size: 16, color: AppColors.primary),
                            label: const Text('تحويل'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => TransferMoneyDialog(defaultFromPlayerId: player.id),
                              );
                            },
                          ),
                          if (!player.isInJail)
                            ActionChip(
                              avatar: const Icon(Icons.lock, size: 16, color: Colors.orange),
                              label: const Text('سجن'),
                              onPressed: () => playerProvider.sendToJail(player.id),
                            )
                          else
                            ActionChip(
                              avatar: const Icon(Icons.lock_open, size: 16, color: Colors.green),
                              label: const Text('كفالة (50£)'),
                              onPressed: () => playerProvider.releaseFromJail(player.id),
                            ),
                          if (!player.isBankrupt)
                            ActionChip(
                              avatar: const Icon(Icons.block, size: 16, color: Colors.red),
                              label: const Text('إفلاس'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('تأكيد الإفلاس'),
                                    content: Text('هل أنت متأكد من إعلان إفلاس اللاعب ${player.name}؟'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                        onPressed: () {
                                          playerProvider.declareBankruptcy(player.id);
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text('إعلان الإفلاس'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
