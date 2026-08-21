import 'dart:math';

class FitnessChallengeItem {
  final String title;
  final String target;
  final int durationSeconds;
  final String instruction;
  final String iconName;

  /// Number of reps to tap through with the counter button, for the
  /// challenges that count reps. Null for time-held ones (plank, wall
  /// sit, balance) where a rep counter doesn't make sense — those still
  /// use the plain success/fail buttons.
  final int? repCountTarget;

  const FitnessChallengeItem({
    required this.title,
    required this.target,
    required this.durationSeconds,
    required this.instruction,
    required this.iconName,
    this.repCountTarget,
  });
}

class FitnessChallengesData {
  FitnessChallengesData._();

  static const List<FitnessChallengeItem> items = [
    FitnessChallengeItem(
      title: 'تحدي تمرين الضغط (Push-ups)',
      target: '10 عدات',
      durationSeconds: 30,
      instruction: 'قم بأداء 10 تكرارات ضغط صحيحة قبل انتهاء العداد!',
      iconName: 'fitness_center',
      repCountTarget: 10,
    ),
    FitnessChallengeItem(
      title: 'تحدي القفز مع فتح الذراعين (Jumping Jacks)',
      target: '20 عدة',
      durationSeconds: 25,
      instruction: 'أنجز 20 قفزة جاكس بنشاط وسرعة!',
      iconName: 'directions_run',
      repCountTarget: 20,
    ),
    FitnessChallengeItem(
      title: 'تحدي تمرين البلانك (Plank)',
      target: 'الثبات لمدة 30 ثانية',
      durationSeconds: 30,
      instruction: 'حافظ على استقامة الظهر والجذع مشدوداً طوال الوقت!',
      iconName: 'accessibility_new',
    ),
    FitnessChallengeItem(
      title: 'تحدي القرفصاء (Squats)',
      target: '15 عدة',
      durationSeconds: 35,
      instruction: 'انزل لزاوية 90 درجة مع الحفاظ على استقامة الصدر!',
      iconName: 'sports_gymnastics',
      repCountTarget: 15,
    ),
    FitnessChallengeItem(
      title: 'تحدي التوازن على قدم واحدة',
      target: '25 ثانية مع إغلاق العينين',
      durationSeconds: 25,
      instruction: 'قف على ساق واحدة واغمض عينيك دون فقدان التوازن!',
      iconName: 'self_improvement',
    ),
    FitnessChallengeItem(
      title: 'تحدي الجلوس على الحائط (Wall Sit)',
      target: '30 ثانية',
      durationSeconds: 30,
      instruction: 'استند على الحائط بزاوية 90 درجة كأنك تجلس على كرسي غير مرئي!',
      iconName: 'chair',
    ),
  ];

  static FitnessChallengeItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
