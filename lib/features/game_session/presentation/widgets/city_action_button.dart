import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';

/// A full-width button used on the results page for buying the city's
/// base plot / garage / market. Shows the purchase price and the rent it
/// will earn, and switches to a disabled "bought" state once owned.
class CityActionButton extends StatelessWidget {
  const CityActionButton({
    super.key,
    required this.icon,
    required this.buyLabel,
    required this.boughtLabel,
    required this.price,
    required this.fee,
    required this.isOwned,
    required this.canAfford,
    required this.onTap,
  });

  final IconData icon;
  final String buyLabel;
  final String boughtLabel;
  final int price;
  final int fee;
  final bool isOwned;
  final bool canAfford;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final disabled = isOwned || !canAfford;

    return Material(
      color: isOwned
          ? AppColors.success.withValues(alpha: 0.12)
          : Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: disabled ? null : onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 12 * scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOwned ? AppColors.success : AppColors.primary.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isOwned ? Icons.check_circle : icon,
                color: isOwned ? AppColors.success : AppColors.primary,
                size: 20 * scale,
              ),
              SizedBox(width: 10 * scale),
              Expanded(
                child: Text(
                  isOwned ? boughtLabel : buyLabel,
                  style: TextStyle(
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.bold,
                    color: disabled && !isOwned ? Colors.grey : null,
                  ),
                ),
              ),
              if (!isOwned)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$price${AppStrings.currency}',
                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.bold,
                        color: canAfford ? AppColors.cashGold : Colors.grey,
                      ),
                    ),
                    Text(
                      'إيجار $fee${AppStrings.currency}',
                      style: TextStyle(fontSize: 10 * scale, color: Colors.grey),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
