import 'dart:math';

class StopTheBusData {
  StopTheBusData._();

  static const List<String> letters = [
    'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'هـ', 'و', 'ي'
  ];

  static const List<String> standardCategories = [
    'اسم ولد',
    'اسم بنت',
    'حيوان',
    'نبات / خضار / فاكهة',
    'جماد',
    'بلد / عاصمة / مدينة',
  ];

  static const List<String> advancedCategories = [
    'مهنة / وظيفة',
    'ماركة / براند شهير',
    'أكلة / وجبة طعام',
    'شيء في المطبخ',
    'وسيلة مواصلات',
    'عنصر كيميائي أو مادة',
    'رياضة أو لعبة',
    'فيلم أو مسلسل',
  ];

  static Map<String, dynamic> generateRandomEasy() {
    final rand = Random();
    final letter = letters[rand.nextInt(letters.length)];
    final shuffled = List<String>.from(standardCategories)..shuffle(rand);
    final selectedCategories = shuffled.take(3).toList();
    return {
      'letter': letter,
      'categories': selectedCategories,
    };
  }

  static Map<String, dynamic> generateRandomHard() {
    final rand = Random();
    final letter = letters[rand.nextInt(letters.length)];
    final allCats = [...standardCategories, ...advancedCategories];
    allCats.shuffle(rand);
    final selectedCategories = allCats.take(5).toList();
    return {
      'letter': letter,
      'categories': selectedCategories,
    };
  }
}
