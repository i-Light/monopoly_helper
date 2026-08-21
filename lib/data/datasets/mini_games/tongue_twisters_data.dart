import 'dart:math';

class TongueTwisterItem {
  final String phrase;
  final int requiredRepetitions;
  final String hint;

  const TongueTwisterItem({
    required this.phrase,
    this.requiredRepetitions = 3,
    required this.hint,
  });
}

class TongueTwistersData {
  TongueTwistersData._();

  static const List<TongueTwisterItem> items = [
    TongueTwisterItem(
      phrase: 'شَرَشَفُنا مَعَ شَرِيفٍ وَشَرَشَفُ شَرِيفٍ مَعَنا',
      requiredRepetitions: 3,
      hint: 'كررها 3 مرات سريعة دون توقف!',
    ),
    TongueTwisterItem(
      phrase: 'خَيْطُ حَرِيرٍ عَلَى حائِطِ خَلِيلٍ',
      requiredRepetitions: 3,
      hint: 'انتبه للتبديل بين الخاء والحاء!',
    ),
    TongueTwisterItem(
      phrase: 'بَقَرَةُ قَمَرٍ حَلَبَتْ حَلِيباً طَيِّباً',
      requiredRepetitions: 3,
      hint: 'كررها 3 مرات بسرعة وبصوت مرتفع!',
    ),
    TongueTwisterItem(
      phrase: 'طَبَقُ مَطَبٍّ طَبَّ فِي طَبَقِ رَطْبٍ',
      requiredRepetitions: 3,
      hint: 'ركز في مخارج حرف الطاء والباء!',
    ),
    TongueTwisterItem(
      phrase: 'قَمِيصُ نَفِيسَةَ نَفِيسٌ جِدّاً',
      requiredRepetitions: 3,
      hint: 'كررها 3 مرات بطلاقة وسرعة!',
    ),
    TongueTwisterItem(
      phrase: 'شَجَرَةُ الجَوْزِ جَزَّتْ جُذُورَهَا',
      requiredRepetitions: 3,
      hint: 'تحدي تكرار حرف الجيم والزاي!',
    ),
  ];

  static TongueTwisterItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
