import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../player_management/state/player_provider.dart';
import '../../../player_management/presentation/dialogs/add_player_dialog.dart';
import '../../../player_management/presentation/dialogs/transfer_money_dialog.dart';

class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final currentPlayer = playerProvider.currentTurnPlayer;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.quickActions,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (currentPlayer != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: currentPlayer.color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: currentPlayer.color),
                  ),
                  child: Text(
                    'دور: ${currentPlayer.name}',
                    style: TextStyle(
                      color: currentPlayer.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.3,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ElevatedButton.icon(
                onPressed: currentPlayer == null
                    ? null
                    : () {
                        playerProvider.passGo(currentPlayer.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حصل ${currentPlayer.name} على 200\$ (GO)')),
                        );
                      },
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                label: const Text('مرور بالبداية (+200\$)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boardGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const TransferMoneyDialog(),
                  );
                },
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('تحويل أموال'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => playerProvider.nextTurn(),
                icon: const Icon(Icons.skip_next, size: 18),
                label: const Text('نقل الدور للتالي'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkSurface,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.darkBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddPlayerDialog(),
                  );
                },
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('إضافة لاعب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
