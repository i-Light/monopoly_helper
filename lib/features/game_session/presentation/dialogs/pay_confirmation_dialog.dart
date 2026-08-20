import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';

/// "Are you sure?" confirmation shown before a player pays the penalty to
/// move despite losing their challenge.
Future<bool> showPayConfirmationDialog(BuildContext context, {required int amount}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(AppStrings.payConfirmTitle),
      content: Text(
        '${AppStrings.payConfirmBody}\n\n'
        '${AppStrings.payToMovePrefix} $amount${AppStrings.currency}',
        style: const TextStyle(height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.payConfirmCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
          child: const Text(AppStrings.payConfirmAccept),
        ),
      ],
    ),
  );
  return result ?? false;
}
