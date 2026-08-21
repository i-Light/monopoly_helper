import 'dart:math';

class WordBanCard {
  final String targetWord;
  final List<String> forbiddenWords;
  final String category;

  const WordBanCard({
    required this.targetWord,
    required this.forbiddenWords,
    required this.category,
  });
}

class WordBanData {
  WordBanData._();

  static const List<WordBanCard> cards = [
    WordBanCard(
      targetWord: 'شاطئ',
      forbiddenWords: ['بحر', 'رمل', 'سباحة', 'صيف', 'ماء'],
      category: 'طبيعة وسياحة',
    ),
    WordBanCard(
      targetWord: 'طبيب',
      forbiddenWords: ['مستشفى', 'دواء', 'مرض', 'سماعة', 'علاج'],
      category: 'مهن',
    ),
    WordBanCard(
      targetWord: 'طائرة',
      forbiddenWords: ['مطار', 'سفر', 'جناح', 'طيار', 'سماء'],
      category: 'مواصلات',
    ),
    WordBanCard(
      targetWord: 'كرة قدم',
      forbiddenWords: ['ملعب', 'هدف', 'حارس', 'مباراة', 'شوت'],
      category: 'رياضة',
    ),
    WordBanCard(
      targetWord: 'بيتزا',
      forbiddenWords: ['جبنة', 'فرن', 'إيطاليا', 'عجينة', 'مثلث'],
      category: 'طعام',
    ),
    WordBanCard(
      targetWord: 'مكتبة',
      forbiddenWords: ['كتب', 'قراءة', 'هدوء', 'استعارة', 'دراسة'],
      category: 'أماكن',
    ),
  ];

  static WordBanCard getRandom() {
    final rand = Random();
    return cards[rand.nextInt(cards.length)];
  }
}
