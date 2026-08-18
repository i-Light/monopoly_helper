enum CardDeckType {
  chance,
  communityChest,
}

enum CardActionType {
  collectMoney,
  payMoney,
  payEachPlayer,
  collectFromEachPlayer,
  goToJail,
  getOutOfJailFree,
  advanceToGo,
  advanceToNearest,
  generalRepairs,
}

class ChanceCardModel {
  final String id;
  final CardDeckType deckType;
  final String titleArabic;
  final String titleEnglish;
  final String descriptionArabic;
  final String descriptionEnglish;
  final CardActionType actionType;
  final int amount;

  const ChanceCardModel({
    required this.id,
    required this.deckType,
    required this.titleArabic,
    required this.titleEnglish,
    required this.descriptionArabic,
    required this.descriptionEnglish,
    required this.actionType,
    this.amount = 0,
  });
}
