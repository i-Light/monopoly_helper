import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/transaction_model.dart';

class PlayerProvider extends ChangeNotifier {
  final List<PlayerModel> _players = [];
  final List<TransactionModel> _transactions = [];

  // Dice State
  int _die1 = 1;
  int _die2 = 1;
  bool _isRolling = false;
  int _consecutiveDoubles = 0;
  String? _diceAlertMessage;

  // Active Player selection for turns
  int _activePlayerIndex = 0;

  PlayerProvider() {
    _initDefaultPlayers();
  }

  void _initDefaultPlayers() {
    _players.addAll([
      PlayerModel(
        id: 'p1',
        name: 'لاعب 1',
        color: AppColors.playerColors[0],
        balance: GameConstants.defaultStartingCash,
      ),
      PlayerModel(
        id: 'p2',
        name: 'لاعب 2',
        color: AppColors.playerColors[1],
        balance: GameConstants.defaultStartingCash,
      ),
      PlayerModel(
        id: 'p3',
        name: 'لاعب 3',
        color: AppColors.playerColors[2],
        balance: GameConstants.defaultStartingCash,
      ),
    ]);
  }

  List<PlayerModel> get players => List.unmodifiable(_players);
  List<PlayerModel> get activePlayers => _players.where((p) => !p.isBankrupt).toList();
  List<TransactionModel> get transactions => List.unmodifiable(_transactions.reversed);

  int get die1 => _die1;
  int get die2 => _die2;
  int get diceTotal => _die1 + _die2;
  bool get isRolling => _isRolling;
  bool get isDouble => _die1 == _die2;
  int get consecutiveDoubles => _consecutiveDoubles;
  String? get diceAlertMessage => _diceAlertMessage;
  int get activePlayerIndex => _activePlayerIndex;
  PlayerModel? get currentTurnPlayer =>
      _players.isNotEmpty && _activePlayerIndex < _players.length ? _players[_activePlayerIndex] : null;

  int get totalCashInGame => _players.fold(0, (sum, p) => sum + p.balance);

  PlayerModel? get leadingPlayer {
    if (_players.isEmpty) return null;
    final sorted = List<PlayerModel>.from(_players)..sort((a, b) => b.netWorth.compareTo(a.netWorth));
    return sorted.first;
  }

  // Player CRUD
  void addPlayer(String name, Color color, {int startingBalance = GameConstants.defaultStartingCash}) {
    final newPlayer = PlayerModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'لاعب ${_players.length + 1}' : name.trim(),
      color: color,
      balance: startingBalance,
    );
    _players.add(newPlayer);
    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        toPlayerId: newPlayer.id,
        toPlayerName: newPlayer.name,
        amount: startingBalance,
        type: TransactionType.bankSalary,
        description: 'انضمام لاعب جديد برصيد افتتاحي $startingBalance\$',
      ),
    );
    notifyListeners();
  }

  void removePlayer(String id) {
    _players.removeWhere((p) => p.id == id);
    if (_activePlayerIndex >= _players.length && _players.isNotEmpty) {
      _activePlayerIndex = 0;
    }
    notifyListeners();
  }

  void nextTurn() {
    if (_players.isEmpty) return;
    _activePlayerIndex = (_activePlayerIndex + 1) % _players.length;
    // Skip bankrupt players
    if (_players[_activePlayerIndex].isBankrupt && activePlayers.isNotEmpty) {
      nextTurn();
    }
    notifyListeners();
  }

  // Banking Operations
  void passGo(String playerId, {int amount = GameConstants.goSalary}) {
    final player = _players.firstWhere((p) => p.id == playerId);
    player.balance += amount;
    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        toPlayerId: player.id,
        toPlayerName: player.name,
        amount: amount,
        type: TransactionType.passGo,
        description: 'المرور بنقطة البداية (GO) +$amount\$',
      ),
    );
    notifyListeners();
  }

  void transferMoney({
    required String fromPlayerId,
    required String toPlayerId,
    required int amount,
    String note = 'تحويل مالي بين لاعبين',
  }) {
    final fromPlayer = _players.firstWhere((p) => p.id == fromPlayerId);
    final toPlayer = _players.firstWhere((p) => p.id == toPlayerId);

    if (fromPlayer.balance < amount) {
      // Allow overdraft or mark note
    }
    fromPlayer.balance -= amount;
    toPlayer.balance += amount;

    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        fromPlayerId: fromPlayer.id,
        fromPlayerName: fromPlayer.name,
        toPlayerId: toPlayer.id,
        toPlayerName: toPlayer.name,
        amount: amount,
        type: TransactionType.transfer,
        description: note,
      ),
    );
    notifyListeners();
  }

  void payToBank(String playerId, int amount, {String note = 'دفع للبنك / ضرائب / شراء'}) {
    final player = _players.firstWhere((p) => p.id == playerId);
    player.balance -= amount;
    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        fromPlayerId: player.id,
        fromPlayerName: player.name,
        amount: amount,
        type: TransactionType.bankPayment,
        description: note,
      ),
    );
    notifyListeners();
  }

  void receiveFromBank(String playerId, int amount, {String note = 'استلام من البنك / أرباح'}) {
    final player = _players.firstWhere((p) => p.id == playerId);
    player.balance += amount;
    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        toPlayerId: player.id,
        toPlayerName: player.name,
        amount: amount,
        type: TransactionType.bankSalary,
        description: note,
      ),
    );
    notifyListeners();
  }

  // Jail Operations
  void sendToJail(String playerId) {
    final player = _players.firstWhere((p) => p.id == playerId);
    player.isInJail = true;
    player.jailTurns = 0;
    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        fromPlayerId: player.id,
        fromPlayerName: player.name,
        amount: 0,
        type: TransactionType.customAdjustment,
        description: 'دخول السجن 🚨',
      ),
    );
    notifyListeners();
  }

  void releaseFromJail(String playerId, {bool payBail = true}) {
    final player = _players.firstWhere((p) => p.id == playerId);
    if (payBail) {
      payToBank(playerId, GameConstants.jailBailCost, note: 'كفالة الخروج من السجن (50\$)');
    }
    player.isInJail = false;
    player.jailTurns = 0;
    notifyListeners();
  }

  void declareBankruptcy(String playerId) {
    final player = _players.firstWhere((p) => p.id == playerId);
    player.isBankrupt = true;
    player.balance = 0;
    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        fromPlayerId: player.id,
        fromPlayerName: player.name,
        amount: 0,
        type: TransactionType.bankruptcy,
        description: 'إعلان الإفلاس والخروج من اللعبة',
      ),
    );
    notifyListeners();
  }

  // Mini-Game Reward / Penalty Resolution
  void resolveMiniGameResult({
    required String playerId,
    required String gameTitle,
    required bool isWon,
    required int rewardAmount,
    required int penaltyAmount,
  }) {
    final player = _players.firstWhere((p) => p.id == playerId);
    player.totalMiniGamesPlayed++;

    if (isWon) {
      player.totalMiniGamesWon++;
      receiveFromBank(
        playerId,
        rewardAmount,
        note: 'مكافأة الفوز في لعبة: $gameTitle (+$rewardAmount\$)',
      );
    } else {
      payToBank(
        playerId,
        penaltyAmount,
        note: 'عقوبة الإخفاق في لعبة: $gameTitle (-$penaltyAmount\$)',
      );
    }
  }

  // Dice Roller Logic
  Future<void> rollDice() async {
    if (_isRolling) return;
    _isRolling = true;
    _diceAlertMessage = null;
    notifyListeners();

    final rand = Random();
    // Simulate dice rolling delay
    await Future.delayed(const Duration(milliseconds: 600));

    _die1 = rand.nextInt(6) + 1;
    _die2 = rand.nextInt(6) + 1;
    _isRolling = false;

    if (_die1 == _die2) {
      _consecutiveDoubles++;
      if (_consecutiveDoubles >= GameConstants.maxConsecutiveDoubles) {
        _diceAlertMessage = '🚨 3 رميات زوجية متتالية! إلى السجن مباشرة!';
        if (currentTurnPlayer != null) {
          sendToJail(currentTurnPlayer!.id);
        }
        _consecutiveDoubles = 0;
      } else {
        _diceAlertMessage = '🎉 زوجي (Double!): رمية إضافية!';
      }
    } else {
      _consecutiveDoubles = 0;
    }

    _logTransaction(
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        fromPlayerId: currentTurnPlayer?.id,
        fromPlayerName: currentTurnPlayer?.name,
        amount: _die1 + _die2,
        type: TransactionType.customAdjustment,
        description: 'رمية نرد: [$_die1 + $_die2 = ${_die1 + _die2}]${isDouble ? ' (زوجي!)' : ''}',
      ),
    );

    notifyListeners();
  }

  void _logTransaction(TransactionModel tx) {
    _transactions.add(tx);
  }

  void clearHistory() {
    _transactions.clear();
    notifyListeners();
  }

  void resetGame() {
    _players.clear();
    _transactions.clear();
    _consecutiveDoubles = 0;
    _activePlayerIndex = 0;
    _initDefaultPlayers();
    notifyListeners();
  }
}
