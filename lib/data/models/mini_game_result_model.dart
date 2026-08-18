import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';

class MiniGameResultModel {
  final String id;
  final String gameId;
  final String gameTitle;
  final MiniGameDifficulty difficulty;
  final String playerId;
  final String playerName;
  final bool isWon;
  final int rewardAmount;
  final int penaltyAmount;
  final DateTime timestamp;
  final String? note;

  MiniGameResultModel({
    required this.id,
    required this.gameId,
    required this.gameTitle,
    required this.difficulty,
    required this.playerId,
    required this.playerName,
    required this.isWon,
    required this.rewardAmount,
    required this.penaltyAmount,
    required this.timestamp,
    this.note,
  });
}
