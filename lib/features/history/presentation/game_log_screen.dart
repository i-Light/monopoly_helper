import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../player_management/state/player_provider.dart';

class GameLogScreen extends StatelessWidget {
  const GameLogScreen({super.key});

  IconData _getIconForType(TransactionType type) {
    switch (type) {
      case TransactionType.passGo:
        return Icons.arrow_forward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.bankPayment:
        return Icons.payment;
      case TransactionType.bankSalary:
        return Icons.account_balance;
      case TransactionType.jailBail:
        return Icons.lock_open;
      case TransactionType.miniGameReward:
        return Icons.emoji_events;
      case TransactionType.miniGamePenalty:
        return Icons.money_off;
      case TransactionType.bankruptcy:
        return Icons.close;
      default:
        return Icons.history;
    }
  }

  Color _getColorForType(TransactionType type) {
    switch (type) {
      case TransactionType.passGo:
      case TransactionType.bankSalary:
      case TransactionType.miniGameReward:
        return AppColors.success;
      case TransactionType.bankPayment:
      case TransactionType.miniGamePenalty:
      case TransactionType.bankruptcy:
        return AppColors.error;
      case TransactionType.transfer:
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final transactions = playerProvider.transactions;
    final timeFormat = DateFormat('HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navHistory),
        actions: [
          if (transactions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: AppStrings.clearHistory,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('مسح السجل'),
                    content: const Text('هل أنت متأكد من رغبتك في مسح سجل العمليات؟'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        onPressed: () {
                          playerProvider.clearHistory();
                          Navigator.pop(ctx);
                        },
                        child: const Text('مسح'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(AppStrings.noTransactions, style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final color = _getColorForType(tx.type);

                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_getIconForType(tx.type), color: color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.description,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              timeFormat.format(tx.timestamp),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      if (tx.amount > 0)
                        Text(
                          '${tx.amount} \$',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: color,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
