import 'dart:math';

class CommonLetterItem {
  final List<String> words;
  final String commonLetter;
  final List<String> options;

  const CommonLetterItem({
    required this.words,
    required this.commonLetter,
    required this.options,
  });
}

class CommonLetterData {
  CommonLetterData._();

  static const List<CommonLetterItem> items = [
    CommonLetterItem(
      words: ['موز', 'نمر', 'شمس', 'قلم'],
      commonLetter: 'م',
      options: ['م', 'ن', 'ر', 'س'],
    ),
    CommonLetterItem(
      words: ['كرسي', 'كتاب', 'كوب', 'سمك'],
      commonLetter: 'ك',
      options: ['ك', 'س', 'ب', 'ر'],
    ),
    CommonLetterItem(
      words: ['جسر', 'بحر', 'قمر', 'رمان'],
      commonLetter: 'ر',
      options: ['ر', 'س', 'ب', 'م'],
    ),
    CommonLetterItem(
      words: ['نجمة', 'نهر', 'ليمون', 'عين'],
      commonLetter: 'ن',
      options: ['ن', 'م', 'هـ', 'ي'],
    ),
    CommonLetterItem(
      words: ['ساعة', 'تفاح', 'بيت', 'حوت'],
      commonLetter: 'ت',
      options: ['ت', 'س', 'ح', 'ة'],
    ),
    CommonLetterItem(
      words: ['عسل', 'عين', 'شارع', 'شمعة'],
      commonLetter: 'ع',
      options: ['ع', 'ش', 'ل', 'ن'],
    ),
  ];

  static CommonLetterItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
