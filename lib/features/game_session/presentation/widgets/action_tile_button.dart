import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';

/// The shared visual shell for every tappable action row on the results
/// page and the prison choice page: a rounded, bordered tile with an
/// icon+label on the left and an optional [trailing] widget on the right.
///
/// [CityActionButton] wraps this for the price/fee buy buttons; the
/// special tiles (club subscribe, prison escape/bail, the insolvency
/// arrest button) use it directly with their own [trailing] content — the
/// "button shape is inherited, what's inside varies" split the results
/// page is built around.
class ActionTileButton extends StatelessWidget {
  const ActionTileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isOwned,
    required this.disabled,
    required this.onTap,
    this.trailing,
    this.accentColor,
  });

  final IconData icon;
  final String label;

  /// Whether this tile represents something already "owned"/completed —
  /// drives the green-tinted styling (same semantic as the old
  /// `CityActionButton.isOwned`).
  final bool isOwned;
  final bool disabled;
  final Widget? trailing;
  final VoidCallback onTap;

  /// Overrides the default primary/success icon+border color — used to
  /// visually set apart buttons that aren't a purchase (e.g. paying rent,
  /// or opting into prison instead).
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final tint = isOwned ? AppColors.success : (accentColor ?? AppColors.primary);

    return RepaintBoundary(
      child: Material(
        color: isOwned
            ? AppColors.success.withValues(alpha: 0.12)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: disabled ? null : onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 14 * scale, vertical: 12 * scale),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isOwned ? AppColors.success : tint.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded (not just an inner Row) so the Flexible label
                // below has a bounded width to shrink into — labels here
                // can be a full sentence (e.g. the prison arrest button),
                // unlike the short buy/sell labels this shell originally
                // shipped with.
                Expanded(
                  child: Row(children: [
                    Icon(
                      icon,
                      color: tint,
                      size: 20 * scale,
                    ),
                    SizedBox(width: 10 * scale),
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.bold,
                          color: disabled && !isOwned ? Colors.grey : null,
                        ),
                      ),
                    ),
                  ]),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
