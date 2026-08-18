import 'dart:math';
import 'package:monopoly_helper/data/models/chance_card_model.dart';

class ChanceCommunityCardsData {
  ChanceCommunityCardsData._();

  static const List<ChanceCardModel> chanceCards = [
    ChanceCardModel(
      id: 'c1',
      deckType: CardDeckType.chance,
      titleArabic: 'تقدم إلى نقطة البداية (GO)',
      titleEnglish: 'Advance to GO',
      descriptionArabic: 'تقدم مباشرة إلى نقطة البداية واجمع 200£ من البنك.',
      descriptionEnglish: 'Collect £200 as you pass GO.',
      actionType: CardActionType.advanceToGo,
      amount: 200,
    ),
    ChanceCardModel(
      id: 'c2',
      deckType: CardDeckType.chance,
      titleArabic: 'عائد استثماري من البنك',
      titleEnglish: 'Bank Dividend',
      descriptionArabic: 'يدفع لك البنك أرباحاً استثمارية قدرها 50£.',
      descriptionEnglish: 'The bank pays you dividends of £50.',
      actionType: CardActionType.collectMoney,
      amount: 50,
    ),
    ChanceCardModel(
      id: 'c3',
      deckType: CardDeckType.chance,
      titleArabic: 'مخالفة سرعة زائدة',
      titleEnglish: 'Speeding Fine',
      descriptionArabic: 'ادفع غرامة قيادة متهورة قدرها 15£ للبنك.',
      descriptionEnglish: 'Pay a £15 fine to the bank.',
      actionType: CardActionType.payMoney,
      amount: 15,
    ),
    ChanceCardModel(
      id: 'c4',
      deckType: CardDeckType.chance,
      titleArabic: 'اذهب مباشرة إلى السجن!',
      titleEnglish: 'Go Directly to Jail',
      descriptionArabic: 'اذهب إلى السجن مباشرة دون المرور بنقطة البداية ولا تجمع 200£.',
      descriptionEnglish: 'Do not pass GO, do not collect £200.',
      actionType: CardActionType.goToJail,
      amount: 0,
    ),
    ChanceCardModel(
      id: 'c5',
      deckType: CardDeckType.chance,
      titleArabic: 'كارت الخروج المجاني من السجن',
      titleEnglish: 'Get Out of Jail Free',
      descriptionArabic: 'احتفظ بهذا الكارت لاستخدامه عند دخول السجن أو بيعه للاعب آخر.',
      descriptionEnglish: 'This card may be kept until needed or traded.',
      actionType: CardActionType.getOutOfJailFree,
      amount: 0,
    ),
    ChanceCardModel(
      id: 'c6',
      deckType: CardDeckType.chance,
      titleArabic: 'انتخابك رئيساً لمجلس الإدارة',
      titleEnglish: 'Elected Chairman',
      descriptionArabic: 'ادفع لكل لاعب آخر 50£ كهدية احتفالية.',
      descriptionEnglish: 'Pay each player £50.',
      actionType: CardActionType.payEachPlayer,
      amount: 50,
    ),
  ];

  static const List<ChanceCardModel> communityChestCards = [
    ChanceCardModel(
      id: 'cc1',
      deckType: CardDeckType.communityChest,
      titleArabic: 'خطأ بنكي لصالحك',
      titleEnglish: 'Bank Error in Your Favor',
      descriptionArabic: 'استلم 200£ من البنك نتيجة تسوية حسابات.',
      descriptionEnglish: 'Collect £200 from the bank.',
      actionType: CardActionType.collectMoney,
      amount: 200,
    ),
    ChanceCardModel(
      id: 'cc2',
      deckType: CardDeckType.communityChest,
      titleArabic: 'فاتورة استشارة الطبيب',
      titleEnglish: 'Doctor Fee',
      descriptionArabic: 'ادفع 50£ أتعاب كشف طبي للبنك.',
      descriptionEnglish: 'Pay £50 to the bank.',
      actionType: CardActionType.payMoney,
      amount: 50,
    ),
    ChanceCardModel(
      id: 'cc3',
      deckType: CardDeckType.communityChest,
      titleArabic: 'استرداد ضريبة الدخل',
      titleEnglish: 'Income Tax Refund',
      descriptionArabic: 'استلم 100£ من البنك كاسترداد ضريبي.',
      descriptionEnglish: 'Collect £100 from the bank.',
      actionType: CardActionType.collectMoney,
      amount: 100,
    ),
    ChanceCardModel(
      id: 'cc4',
      deckType: CardDeckType.communityChest,
      titleArabic: 'يوم ميلادك السعيد!',
      titleEnglish: 'It is Your Birthday',
      descriptionArabic: 'اجمع 10£ هدية من كل لاعب في اللعبة.',
      descriptionEnglish: 'Collect £10 from each player.',
      actionType: CardActionType.collectFromEachPlayer,
      amount: 10,
    ),
    ChanceCardModel(
      id: 'cc5',
      deckType: CardDeckType.communityChest,
      titleArabic: 'أقساط التأمين مستحقة',
      titleEnglish: 'Insurance Premium Due',
      descriptionArabic: 'ادفع 50£ للبنك قيمة بوليصة التأمين السنوية.',
      descriptionEnglish: 'Pay £50 to the bank.',
      actionType: CardActionType.payMoney,
      amount: 50,
    ),
  ];

  static ChanceCardModel drawChance() {
    final rand = Random();
    return chanceCards[rand.nextInt(chanceCards.length)];
  }

  static ChanceCardModel drawCommunityChest() {
    final rand = Random();
    return communityChestCards[rand.nextInt(communityChestCards.length)];
  }
}
