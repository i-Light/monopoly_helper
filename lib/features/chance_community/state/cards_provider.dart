import 'package:flutter/material.dart';
import '../../../data/datasets/chance_community_cards_data.dart';
import '../../../data/models/chance_card_model.dart';
import '../../player_management/state/player_provider.dart';

class CardsProvider extends ChangeNotifier {
  ChanceCardModel? _lastDrawnCard;
  CardDeckType _activeDeck = CardDeckType.chance;
  bool _isCardFlipped = false;

  ChanceCardModel? get lastDrawnCard => _lastDrawnCard;
  CardDeckType get activeDeck => _activeDeck;
  bool get isCardFlipped => _isCardFlipped;

  void selectDeck(CardDeckType deck) {
    _activeDeck = deck;
    _lastDrawnCard = null;
    _isCardFlipped = false;
    notifyListeners();
  }

  void drawCard() {
    if (_activeDeck == CardDeckType.chance) {
      _lastDrawnCard = ChanceCommunityCardsData.drawChance();
    } else {
      _lastDrawnCard = ChanceCommunityCardsData.drawCommunityChest();
    }
    _isCardFlipped = true;
    notifyListeners();
  }

  void resetCard() {
    _lastDrawnCard = null;
    _isCardFlipped = false;
    notifyListeners();
  }

  void applyCardEffect(PlayerProvider playerProvider, String targetPlayerId) {
    if (_lastDrawnCard == null) return;
    final card = _lastDrawnCard!;

    switch (card.actionType) {
      case CardActionType.collectMoney:
        playerProvider.receiveFromBank(targetPlayerId, card.amount, note: 'كارت حظ: ${card.titleArabic}');
        break;
      case CardActionType.payMoney:
        playerProvider.payToBank(targetPlayerId, card.amount, note: 'كارت حظ: ${card.titleArabic}');
        break;
      case CardActionType.advanceToGo:
        playerProvider.passGo(targetPlayerId, amount: card.amount);
        break;
      case CardActionType.goToJail:
        playerProvider.sendToJail(targetPlayerId);
        break;
      case CardActionType.getOutOfJailFree:
        break;
      case CardActionType.payEachPlayer:
        for (var p in playerProvider.activePlayers) {
          if (p.id != targetPlayerId) {
            playerProvider.transferMoney(
              fromPlayerId: targetPlayerId,
              toPlayerId: p.id,
              amount: card.amount,
              note: 'كارت حظ: دفع لكل لاعب',
            );
          }
        }
        break;
      case CardActionType.collectFromEachPlayer:
        for (var p in playerProvider.activePlayers) {
          if (p.id != targetPlayerId) {
            playerProvider.transferMoney(
              fromPlayerId: p.id,
              toPlayerId: targetPlayerId,
              amount: card.amount,
              note: 'كارت حظ: جمع من كل لاعب',
            );
          }
        }
        break;
      default:
        break;
    }

    notifyListeners();
  }
}
