import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/action_tile_button.dart';

/// The "pay rent and end turn" button shown when standing on another
/// player's city. Deliberately styled apart from [CityActionButton]'s
/// buy buttons (amber accent, single amount) since paying rent isn't a
/// purchase — it only ever shows the fee owed, not a price.
class PayFeeButton extends StatelessWidget {
  const PayFeeButton({
    super.key,
    required this.fee,
    required this.canAfford,
    required this.onTap,
  });

  final int fee;
  final bool canAfford;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return ActionTileButton(
      icon: Icons.payments,
      label: AppStrings.payOwnerAndFinish,
      isOwned: false,
      disabled: !canAfford,
      accentColor: AppColors.warning,
      onTap: onTap,
      trailing: Text(
        '$fee${AppStrings.currency}',
        style: TextStyle(
          fontSize: 20 * scale,
          fontWeight: FontWeight.bold,
          color: canAfford ? AppColors.warning : Colors.grey,
        ),
      ),
    );
  }
}
