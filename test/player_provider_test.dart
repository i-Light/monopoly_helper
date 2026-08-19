import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_helper/features/player_management/state/player_provider.dart';

void main() {
  group('PlayerProvider Monopoly Bank Tests', () {
    late PlayerProvider provider;

    setUp(() {
      provider = PlayerProvider();
    });

    test('Initializes with default players', () {
      expect(provider.players.length, 3);
      expect(provider.activePlayers.length, 3);
      expect(provider.players.first.balance, 1500);
    });

    test('Pass GO adds 200 to player balance', () {
      final p1 = provider.players.first;
      final initialBalance = p1.balance;
      provider.passGo(p1.id);
      expect(p1.balance, initialBalance + 200);
      expect(provider.transactions.first.amount, 200);
    });

    test('Transfer money moves exact amount between players', () {
      final p1 = provider.players[0];
      final p2 = provider.players[1];
      final p1Init = p1.balance;
      final p2Init = p2.balance;

      provider.transferMoney(
        fromPlayerId: p1.id,
        toPlayerId: p2.id,
        amount: 250,
      );

      expect(p1.balance, p1Init - 250);
      expect(p2.balance, p2Init + 250);
    });

    test('Send to Jail and release with bail updates state', () {
      final p1 = provider.players.first;
      provider.sendToJail(p1.id);
      expect(p1.isInJail, true);

      final bal = p1.balance;
      provider.releaseFromJail(p1.id, payBail: true);
      expect(p1.isInJail, false);
      expect(p1.balance, bal - 50);
    });

    test('Declare bankruptcy sets balance to 0 and marks status', () {
      final p1 = provider.players.first;
      provider.declareBankruptcy(p1.id);
      expect(p1.isBankrupt, true);
      expect(p1.balance, 0);
      expect(provider.activePlayers.length, 2);
    });

    test('Resolve MiniGame result awards or penalizes cash', () {
      final p1 = provider.players.first;
      final initBal = p1.balance;

      // Win reward +100
      provider.resolveMiniGameResult(
        playerId: p1.id,
        gameTitle: 'Speed Math',
        isWon: true,
        rewardAmount: 100,
        penaltyAmount: 50,
      );
      expect(p1.balance, initBal + 100);
      expect(p1.totalMiniGamesWon, 1);
      expect(p1.totalMiniGamesPlayed, 1);

      // Loss penalty -50
      provider.resolveMiniGameResult(
        playerId: p1.id,
        gameTitle: 'Rhyme Challenge',
        isWon: false,
        rewardAmount: 100,
        penaltyAmount: 50,
      );
      expect(p1.balance, initBal + 100 - 50);
      expect(p1.totalMiniGamesPlayed, 2);
    });
  });
}
