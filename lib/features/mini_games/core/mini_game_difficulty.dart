import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';

enum MiniGameDifficulty {
  easy,
  medium,
  hard;

  String get labelArabic {
    switch (this) {
      case MiniGameDifficulty.easy:
        return 'سهل (Easy)';
      case MiniGameDifficulty.medium:
        return 'متوسط (Medium)';
      case MiniGameDifficulty.hard:
        return 'صعب (Hard)';
    }
  }

  /// Steps range this tier covers on the 3x3 moves grid — shown instead of
  /// the "easy/medium/hard" word so the player sees why a challenge is
  /// tougher (they picked more steps), not just a subjective label.
  String get stepsRangeLabel {
    switch (this) {
      case MiniGameDifficulty.easy:
        return '1-3';
      case MiniGameDifficulty.medium:
        return '4-6';
      case MiniGameDifficulty.hard:
        return '7-9';
    }
  }

  String get labelEnglish {
    switch (this) {
      case MiniGameDifficulty.easy:
        return 'Easy';
      case MiniGameDifficulty.medium:
        return 'Medium';
      case MiniGameDifficulty.hard:
        return 'Hard';
    }
  }

  Color get color {
    switch (this) {
      case MiniGameDifficulty.easy:
        return AppColors.easyTier;
      case MiniGameDifficulty.medium:
        return AppColors.mediumTier;
      case MiniGameDifficulty.hard:
        return AppColors.hardTier;
    }
  }

  IconData get icon {
    switch (this) {
      case MiniGameDifficulty.easy:
        return Icons.star_border;
      case MiniGameDifficulty.medium:
        return Icons.star_half;
      case MiniGameDifficulty.hard:
        return Icons.star;
    }
  }

  int get defaultReward {
    switch (this) {
      case MiniGameDifficulty.easy:
        return GameConstants.easyReward;
      case MiniGameDifficulty.medium:
        return GameConstants.mediumReward;
      case MiniGameDifficulty.hard:
        return GameConstants.hardReward;
    }
  }

  int get defaultPenalty {
    switch (this) {
      case MiniGameDifficulty.easy:
        return GameConstants.easyPenalty;
      case MiniGameDifficulty.medium:
        return GameConstants.mediumPenalty;
      case MiniGameDifficulty.hard:
        return GameConstants.hardPenalty;
    }
  }
}
