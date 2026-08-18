import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/features/player_management/state/player_provider.dart';

class TransferMoneyDialog extends StatefulWidget {
  final String? defaultFromPlayerId;

  const TransferMoneyDialog({super.key, this.defaultFromPlayerId});

  @override
  State<TransferMoneyDialog> createState() => _TransferMoneyDialogState();
}

class _TransferMoneyDialogState extends State<TransferMoneyDialog> {
  String? _fromPlayerId;
  String? _toPlayerId;
  final _amountController = TextEditingController(text: '100');
  final _noteController = TextEditingController(text: 'إيجار / شراء عقار / مبادلة');

  @override
  void initState() {
    super.initState();
    final players = context.read<PlayerProvider>().activePlayers;
    if (players.isNotEmpty) {
      _fromPlayerId = widget.defaultFromPlayerId ?? players.first.id;
      final otherPlayers = players.where((p) => p.id != _fromPlayerId).toList();
      _toPlayerId = otherPlayers.isNotEmpty ? otherPlayers.first.id : players.first.id;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final players = playerProvider.activePlayers;

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.swap_horiz, color: AppColors.primary),
          SizedBox(width: 8),
          Text(AppStrings.transferMoney),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _fromPlayerId,
              decoration: const InputDecoration(labelText: AppStrings.fromPlayer),
              items: players
                  .map((p) => DropdownMenuItem(
                        value: p.id,
                        child: Text('${p.name} (رصيده: ${p.balance} £)'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _fromPlayerId = val),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _toPlayerId,
              decoration: const InputDecoration(labelText: AppStrings.toPlayer),
              items: players
                  .map((p) => DropdownMenuItem(
                        value: p.id,
                        child: Text('${p.name} (رصيده: ${p.balance} £)'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _toPlayerId = val),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.amount,
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: AppStrings.note,
                prefixIcon: Icon(Icons.comment),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_fromPlayerId == null || _toPlayerId == null || _fromPlayerId == _toPlayerId) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الرجاء اختيار طرفين مختلفين للتحويل')),
              );
              return;
            }
            final amount = int.tryParse(_amountController.text) ?? 0;
            if (amount <= 0) return;

            playerProvider.transferMoney(
              fromPlayerId: _fromPlayerId!,
              toPlayerId: _toPlayerId!,
              amount: amount,
              note: _noteController.text.trim(),
            );
            Navigator.pop(context);
          },
          child: const Text(AppStrings.confirm),
        ),
      ],
    );
  }
}
