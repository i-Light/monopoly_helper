import 'dart:math';

class ReverseWordItem {
  final String word;
  final String reversed;
  final String hint;

  const ReverseWordItem({
    required this.word,
    required this.reversed,
    required this.hint,
  });
}

class ReverseWordsData {
  ReverseWordsData._();

  static const List<ReverseWordItem> items = [
    ReverseWordItem(word: 'تمساح', reversed: 'حاسمت', hint: 'حيوان مائي مفترس'),
    ReverseWordItem(word: 'شمسية', reversed: 'ةيسمش', hint: 'للحماية من المطر'),
    ReverseWordItem(word: 'صاروخ', reversed: 'خوارص', hint: 'ينطلق للفضاء'),
    ReverseWordItem(word: 'طائرة', reversed: 'ةرئاط', hint: 'وسيلة نقل جوية'),
    ReverseWordItem(word: 'مفتاح', reversed: 'حاتفم', hint: 'لفتح الأبواب'),
    ReverseWordItem(word: 'برتقال', reversed: 'لاقترب', hint: 'فاكهة شتوية حمضية'),
    ReverseWordItem(word: 'مصباح', reversed: 'حابصم', hint: 'مصدر للإنارة'),
    ReverseWordItem(word: 'فنجان', reversed: 'ناجنف', hint: 'لشرب القهوة'),
    ReverseWordItem(word: 'سفينة', reversed: 'ةنيفَس', hint: 'تبحر في المحيط'),
    ReverseWordItem(word: 'كمبيوتر', reversed: 'رتويبمك', hint: 'جهاز رقمي ذكي'),
  ];

  static ReverseWordItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
