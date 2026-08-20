import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/data/models/player_model.dart';

/// The results page's ownership indicator: the owning player's initials
/// inside a rounded frame tinted with their color, topped with a golden
/// crown. Only rendered at all when the city is owned by someone — the
/// caller is expected to simply not build this widget otherwise.
class OwnerBadge extends StatelessWidget {
  const OwnerBadge({super.key, this.owner});

  final PlayerModel? owner;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    Container addOwner(PlayerModel? owner) {
      if (owner == null) {
        return Container();
      } else {
        return Container(
          padding:
              EdgeInsets.symmetric(horizontal: 11 * scale, vertical: 6 * scale),
          decoration: BoxDecoration(
            color: owner.color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Text(
            owner.initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14 * scale,
            ),
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.emoji_events,
            color: owner != null
                ? const Color(0xFFFFD700)
                : const Color.fromARGB(255, 74, 76, 81),
            size: 22 * scale),
        SizedBox(height: 2 * scale),
        addOwner(owner)
      ],
    );
  }
}
