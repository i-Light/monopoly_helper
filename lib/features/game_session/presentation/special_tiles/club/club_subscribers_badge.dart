import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/data/models/player_model.dart';

/// Replaces [OwnerBadge] for the club tile: shows one chip per current
/// subscriber (their initials, tinted with their color) plus a faded
/// "open slot" chip for each remaining seat up to [capacity] — so a club
/// with one subscriber and capacity 2 visibly shows room for one more.
class ClubSubscribersBadge extends StatelessWidget {
  const ClubSubscribersBadge(
      {super.key, required this.subscribers, required this.capacity});

  final List<PlayerModel> subscribers;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    Widget slot({PlayerModel? player}) {
      if (player != null) {
        return Row(children: [
          Container(
            margin: EdgeInsets.only(top: 2 * scale),
            padding: EdgeInsets.symmetric(
                horizontal: 11 * scale, vertical: 6 * scale),
            decoration: BoxDecoration(
              color: player.color.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Text(
              player.initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14 * scale,
              ),
            ),
          ),
          SizedBox(width: 3 * scale),
        ]);
      }
      return Container(
        margin: EdgeInsets.only(top: 2 * scale),
        padding:
            EdgeInsets.symmetric(horizontal: 9 * scale, vertical: 6 * scale),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.5),
            style: BorderStyle.solid,
          ),
        ),
        child: Icon(Icons.add, size: 14 * scale, color: Colors.grey),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.groups,
            color: subscribers.isNotEmpty
                ? const Color(0xFFFFD700)
                : const Color.fromARGB(255, 74, 76, 81),
            size: 22 * scale),
        SizedBox(height: 2 * scale),
        Row(
          children: [
            for (var i = capacity - 1; i > -1; i--)
              slot(player: i < subscribers.length ? subscribers[i] : null),
          ],
        ),
      ],
    );
  }
}
