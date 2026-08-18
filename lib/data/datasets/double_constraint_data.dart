import 'dart:math';

class DoubleConstraintItem {
  final String constraint1;
  final String constraint2;
  final List<String> exampleSolutions;

  const DoubleConstraintItem({
    required this.constraint1,
    required this.constraint2,
    required this.exampleSolutions,
  });
}

class DoubleConstraintData {
  DoubleConstraintData._();

  static const List<DoubleConstraintItem> items = [
    DoubleConstraintItem(
      constraint1: 'تبدأ بحرف (س)',
      constraint2: 'تنتهي بحرف (ل)',
      exampleSolutions: ['سائل', 'ساحل', 'سهل', 'سربال', 'سؤال'],
    ),
    DoubleConstraintItem(
      constraint1: 'اسم حيوان',
      constraint2: 'يتكون من 4 حروف بالضبط ويبدأ بحرف (ث)',
      exampleSolutions: ['ثعلب', 'ثعبان'],
    ),
    DoubleConstraintItem(
      constraint1: 'اسم دولة عربية',
      constraint2: 'تنتهي بحرف (ن)',
      exampleSolutions: ['لبنان', 'عمان', 'السودان', 'البحرين', 'اليمن'],
    ),
    DoubleConstraintItem(
      constraint1: 'اسم نبات أو فاكهة',
      constraint2: 'يبدأ بحرف (ب) ويحتوي على حرف (ق)',
      exampleSolutions: ['برتقال', 'بندق', 'باقلاء', 'برقوق'],
    ),
    DoubleConstraintItem(
      constraint1: 'تبدأ بحرف (م)',
      constraint2: 'تنتهي بحرف (ة / هـ) وتتكون من 5 أحرف',
      exampleSolutions: ['مدينة', 'مدرسة', 'مزرعة', 'مملكة', 'مكتبة'],
    ),
  ];

  static DoubleConstraintItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
