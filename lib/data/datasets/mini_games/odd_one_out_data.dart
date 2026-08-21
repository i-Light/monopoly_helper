import 'dart:math';

class OddOneOutItem {
  final List<String> words;
  final int oddIndex;
  final String reason;
  final String groupCategory;

  const OddOneOutItem({
    required this.words,
    required this.oddIndex,
    required this.reason,
    required this.groupCategory,
  });
}

class OddOneOutData {
  OddOneOutData._();

  static const List<OddOneOutItem> items = [
    OddOneOutItem(
      words: ['تفاح', 'موز', 'خيار', 'برتقال'],
      oddIndex: 2,
      reason: 'الخيار خضار بينما البقية فواكه.',
      groupCategory: 'أطعمة',
    ),
    OddOneOutItem(
      words: ['أسد', 'نمر', 'فهد', 'نسر'],
      oddIndex: 3,
      reason: 'النسر طائر بينما البقية ثدييات مفترسة.',
      groupCategory: 'حيوانات',
    ),
    OddOneOutItem(
      words: ['مصر', 'السعودية', 'إسبانيا', 'الأردن'],
      oddIndex: 2,
      reason: 'إسبانيا دولة أوروبية بينما البقية دول عربية.',
      groupCategory: 'جغرافيا',
    ),
    OddOneOutItem(
      words: ['طائرة', 'سيارة', 'قطار', 'حافلة'],
      oddIndex: 0,
      reason: 'الطائرة وسيلة نقل جوية بينما البقية وسائل برية.',
      groupCategory: 'مواصلات',
    ),
    OddOneOutItem(
      words: ['المشتري', 'المريخ', 'القمر', 'زحل'],
      oddIndex: 2,
      reason: 'القمر تابع أرضي طبيعي بينما البقية كواكب في المجموعة الشمسية.',
      groupCategory: 'فضاء',
    ),
    OddOneOutItem(
      words: ['حديد', 'ذهب', 'خشب', 'نحاس'],
      oddIndex: 2,
      reason: 'الخشب مادة عضوية غير معدنية بينما البقية معادن.',
      groupCategory: 'مواد',
    ),
  ];

  static OddOneOutItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
