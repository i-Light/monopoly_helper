import 'dart:math';

class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String category;

  const TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
  });
}

class TriviaQuestionsData {
  TriviaQuestionsData._();

  static const List<TriviaQuestion> items = [
    TriviaQuestion(
      question: 'ما هو أطول نهر في العالم؟',
      options: ['نهر الأمازون', 'نهر النيل', 'نهر المسيسيبي', 'نهر الدانوب'],
      correctIndex: 1,
      explanation: 'نهر النيل هو أطول أنهار الكرة الأرضية بطول يقارب 6,650 كم.',
      category: 'جغرافيا',
    ),
    TriviaQuestion(
      question: 'ما هو العنصر الكيميائي الذي يرمز له بالرمز (Au)؟',
      options: ['الفضة', 'الذهب', 'الألومنيوم', 'النحاس'],
      correctIndex: 1,
      explanation: 'رمز الذهب مشتق من الكلمة اللاتينية Aurum.',
      category: 'علوم',
    ),
    TriviaQuestion(
      question: 'كم عدد قارات العالم المأهولة بالسكان؟',
      options: ['5', '6', '7', '8'],
      correctIndex: 1,
      explanation: 'يوجد 6 قارات مأهولة، حيث أن القارة القطبية الجنوبية غير مأهولة بشكل دائم.',
      category: 'جغرافيا',
    ),
    TriviaQuestion(
      question: 'ما الشيء الذي يمشي بأربع أرجل في الصباح، واثنتين في الظهيرة، وثلاث في المساء؟',
      options: ['الساعة', 'الإنسان', 'الشمس', 'الظل'],
      correctIndex: 1,
      explanation: 'لغز أبي الهول الشهير: الإنسان يحبو طفلاً، ويمشي على قدميه شاباً، ويتوكأ على عصا شيخاً.',
      category: 'ألغاز ومنطق',
    ),
    TriviaQuestion(
      question: 'ما هي عاصمة أستراليا الرسمية؟',
      options: ['سيدني', 'ملبورن', 'كانبرا', 'بيرث'],
      correctIndex: 2,
      explanation: 'كانبرا هي العاصمة الفيدرالية لأستراليا وليست سيدني.',
      category: 'جغرافيا',
    ),
    TriviaQuestion(
      question: 'ما هو الكوكب الأقرب إلى الشمس في المجموعة الشمسية؟',
      options: ['الزهرة', 'المريخ', 'عطارد', 'الأرض'],
      correctIndex: 2,
      explanation: 'عطارد هو الكوكب الأقرب للشمس والأصغر حجماً.',
      category: 'فضاء',
    ),
    TriviaQuestion(
      question: 'إذا كان لديك 5 تفاحات وأخذت منها 3 تفاحات، كم تفاحة أصبحت تملك؟',
      options: ['تفاحتان', '3 تفاحات', '5 تفاحات', 'صفر'],
      correctIndex: 1,
      explanation: 'أنت أخذت 3 تفاحات، إذن تملك الـ 3 تفاحات التي أخذتها!',
      category: 'ألغاز ومنطق',
    ),
    TriviaQuestion(
      question: 'من هو مخترع المصباح الكهربائي العملي؟',
      options: ['نيكولا تسلا', 'توماس إديسون', 'ألكسندر غراهام بل', 'ألبرت أينشتاين'],
      correctIndex: 1,
      explanation: 'توماس إديسون طوّر المصباح المتوهج القابل للاستخدام التجاري.',
      category: 'تاريخ واختراعات',
    ),
    TriviaQuestion(
      question: 'ما هو أكبر محيطات العالم مساحة؟',
      options: ['المحيط الأطلسي', 'المحيط الهندي', 'المحيط الهادئ', 'المحيط المتجمد'],
      correctIndex: 2,
      explanation: 'المحيط الهادئ يغطي أكثر من 30% من مساحة سطح الأرض.',
      category: 'جغرافيا',
    ),
  ];

  static TriviaQuestion getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
