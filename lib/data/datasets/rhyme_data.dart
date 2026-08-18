import 'dart:math';

class RhymeItem {
  final String baseWord;
  final List<String> validRhymes;
  final int requiredCount;

  const RhymeItem({
    required this.baseWord,
    required this.validRhymes,
    this.requiredCount = 3,
  });
}

class RhymeData {
  RhymeData._();

  static const List<RhymeItem> items = [
    RhymeItem(
      baseWord: 'سماء',
      validRhymes: ['فضاء', 'بناء', 'عطاء', 'وفاء', 'هواء', 'شفاء', 'ضياء', 'دعاء', 'رجاء', 'مساء', 'صفاء'],
    ),
    RhymeItem(
      baseWord: 'كتاب',
      validRhymes: ['سحاب', 'أبواب', 'جواب', 'عذاب', 'حساب', 'تراب', 'سراب', 'أصحاب', 'غياب', 'شباب'],
    ),
    RhymeItem(
      baseWord: 'نور',
      validRhymes: ['سرور', 'زهور', 'طيور', 'بحور', 'صخور', 'بدور', 'سطور', 'قصور', 'عطور', 'حبور'],
    ),
    RhymeItem(
      baseWord: 'جميل',
      validRhymes: ['خليل', 'دليل', 'أصيل', 'سبيل', 'نبيل', 'طويل', 'ثقيل', 'قليل', 'نخيل', 'عليل'],
    ),
    RhymeItem(
      baseWord: 'قمر',
      validRhymes: ['سهر', 'شجر', 'بحر', 'مطر', 'عطر', 'سفر', 'نظر', 'أثر', 'حجر', 'نهر', 'بشر'],
    ),
    RhymeItem(
      baseWord: 'زمان',
      validRhymes: ['مكان', 'أمان', 'حنان', 'بيان', 'لسان', 'بستان', 'شجعان', 'برهان', 'فرسان', 'إحسان'],
    ),
    RhymeItem(
      baseWord: 'سلام',
      validRhymes: ['كلام', 'حمام', 'أحلام', 'أيام', 'نظام', 'كرام', 'إمام', 'ظلام', 'ختام', 'سهام'],
    ),
  ];

  static RhymeItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
