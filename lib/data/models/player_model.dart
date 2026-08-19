import 'package:flutter/material.dart';

class PlayerModel {
  final String id;
  String name;
  Color color;
  int balance;
  List<String> properties;
  bool isInJail;
  int jailTurns;
  bool isBankrupt;
  int totalMiniGamesPlayed;
  int totalMiniGamesWon;

  PlayerModel({
    required this.id,
    required this.name,
    required this.color,
    this.balance = 1500,
    List<String>? properties,
    this.isInJail = false,
    this.jailTurns = 0,
    this.isBankrupt = false,
    this.totalMiniGamesPlayed = 0,
    this.totalMiniGamesWon = 0,
  }) : properties = properties ?? [];

  int get netWorth => balance + (properties.length * 150); // Estimated property value

  PlayerModel copyWith({
    String? id,
    String? name,
    Color? color,
    int? balance,
    List<String>? properties,
    bool? isInJail,
    int? jailTurns,
    bool? isBankrupt,
    int? totalMiniGamesPlayed,
    int? totalMiniGamesWon,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      properties: properties ?? List.from(this.properties),
      isInJail: isInJail ?? this.isInJail,
      jailTurns: jailTurns ?? this.jailTurns,
      isBankrupt: isBankrupt ?? this.isBankrupt,
      totalMiniGamesPlayed: totalMiniGamesPlayed ?? this.totalMiniGamesPlayed,
      totalMiniGamesWon: totalMiniGamesWon ?? this.totalMiniGamesWon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorValue': color.toARGB32(),
      'balance': balance,
      'properties': properties,
      'isInJail': isInJail,
      'jailTurns': jailTurns,
      'isBankrupt': isBankrupt,
      'totalMiniGamesPlayed': totalMiniGamesPlayed,
      'totalMiniGamesWon': totalMiniGamesWon,
    };
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      color: Color(json['colorValue'] as int),
      balance: json['balance'] as int? ?? 1500,
      properties: List<String>.from(json['properties'] ?? []),
      isInJail: json['isInJail'] as bool? ?? false,
      jailTurns: json['jailTurns'] as int? ?? 0,
      isBankrupt: json['isBankrupt'] as bool? ?? false,
      totalMiniGamesPlayed: json['totalMiniGamesPlayed'] as int? ?? 0,
      totalMiniGamesWon: json['totalMiniGamesWon'] as int? ?? 0,
    );
  }
}
