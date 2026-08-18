import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class QuickAmountDialog extends StatefulWidget {
  final String title;
  final String playerName;
  final ValueChanged<int> onConfirm;

  const QuickAmountDialog({
    super.key,
    required this.title,
    required this.playerName,
    required this.onConfirm,
  });

  @override
  State<QuickAmountDialog> createState() => _QuickAmountDialogState();
}

class _QuickAmountDialogState extends State<QuickAmountDialog> {
  final _amountController = TextEditingController(text: '50');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اللاعب: ${widget.playerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: AppStrings.amount,
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: [20, 50, 100, 150, 200, 500].map((val) {
              return ActionChip(
                label: Text('+$val\$'),
                onPressed: () => setState(() => _amountController.text = '$val'),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
        ElevatedButton(
          onPressed: () {
            final amt = int.tryParse(_amountController.text) ?? 0;
            if (amt > 0) widget.onConfirm(amt);
            Navigator.pop(context);
          },
          child: const Text(AppStrings.confirm),
        ),
      ],
    );
  }
}
