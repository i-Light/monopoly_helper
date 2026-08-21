import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/action_tile_button.dart';

/// A full-width button used on the results page for buying the city's
/// base plot / garage / market. Shows the purchase price and the rent it
/// will earn, and switches to a disabled "bought" state once owned.
///
/// Thin wrapper over [ActionTileButton] — the price/fee trailing column
/// is the only thing specific to a price/fee purchase; everything else
/// (the tile's shape) is the shared shell other special-tile buttons
/// reuse directly.
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
    final disabled = isOwned || !canAfford;

    return ActionTileButton(
      icon: isOwned ? Icons.check_circle : icon,
      label: isOwned ? boughtLabel : buyLabel,
      isOwned: isOwned,
      disabled: disabled,
      onTap: onTap,
      trailing: isOwned
          ? null
          : _PriceFeeColumn(price: price, fee: fee, canAfford: canAfford),
    );
  }
}

class _PriceFeeColumn extends StatelessWidget {
  const _PriceFeeColumn(
      {required this.price, required this.fee, required this.canAfford});

  final int price;
  final int fee;
  final bool canAfford;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$price${AppStrings.currency}',
          style: TextStyle(
            fontSize: 18 * scale,
            fontWeight: FontWeight.bold,
            color: canAfford ? AppColors.cashGold : Colors.grey,
          ),
        ),
        Text(
          'مرور $fee${AppStrings.currency}',
          style: TextStyle(fontSize: 20 * scale, color: Colors.grey),
        ),
      ],
    );
  }
}
