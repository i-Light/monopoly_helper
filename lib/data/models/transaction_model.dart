enum TransactionType {
  passGo,
  transfer,
  bankPayment,
  bankSalary,
  jailBail,
  miniGameReward,
  miniGamePenalty,
  propertyBuy,
  chanceCard,
  bankruptcy,
  customAdjustment,
}

class TransactionModel {
  final String id;
  final DateTime timestamp;
  final String? fromPlayerId;
  final String? fromPlayerName;
  final String? toPlayerId;
  final String? toPlayerName;
  final int amount;
  final TransactionType type;
  final String description;

  TransactionModel({
    required this.id,
    required this.timestamp,
    this.fromPlayerId,
    this.fromPlayerName,
    this.toPlayerId,
    this.toPlayerName,
    required this.amount,
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'fromPlayerId': fromPlayerId,
      'fromPlayerName': fromPlayerName,
      'toPlayerId': toPlayerId,
      'toPlayerName': toPlayerName,
      'amount': amount,
      'type': type.name,
      'description': description,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      fromPlayerId: json['fromPlayerId'] as String?,
      fromPlayerName: json['fromPlayerName'] as String?,
      toPlayerId: json['toPlayerId'] as String?,
      toPlayerName: json['toPlayerName'] as String?,
      amount: json['amount'] as int,
      type: TransactionType.values.firstWhere((e) => e.name == json['type'], orElse: () => TransactionType.customAdjustment),
      description: json['description'] as String,
    );
  }
}
