import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';

class DifficultyBadge extends StatelessWidget {
  final MiniGameDifficulty difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: difficulty.color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: difficulty.color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(difficulty.icon, size: 13, color: difficulty.color),
          const SizedBox(width: 4),
          Text(
            difficulty.labelArabic,
            style: TextStyle(
              color: difficulty.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
