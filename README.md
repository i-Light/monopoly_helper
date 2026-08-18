# مساعد مونوبولي | Monopoly Helper (Flutter Edition)

مشروع فلتر (Flutter) احترافي، معياري (Modular)، وسريع التجاوب لإدارة جلسات لعبة مونوبولي (Monopoly Companion & Banking App) متكامل مع باقة تضم **14 لعبة وتحدي مصغر تفاعلي** (Mini-Games Suite) عبر ثلاثة مستويات صعوبة (سهل، متوسط، صعب).

تم تحويل هذا المشروع وتطويره من مشروع CustomTkinter الأصلي إلى بنية فلتر معيارية حديثة جاهزة للبناء والتوسيع المستمر.

---

## 🌟 الميزات الرئيسية (Key Features)

### 🏦 1. البنك الذكي وإدارة اللاعبين (Monopoly Banking & Player Management)
- **إدارة كاملة للأرصدة**: تتبع رصيد كل لاعب، صافي الثروة (Net Worth)، وحالة العقارات.
- **إجراءات بنكية سريعة**: المرور بنقطة البداية (Pass GO +200$)، الإيداع، الخصم، ودفع الإيجار.
- **تحويل الأموال**: تحويل سلس ومباشر بين أي لاعبين مع تدوين الملاحظات.
- **نظام السجن والإفلاس**: تتبع حالة السجن، دفع الكفالة (50$)، وإعلان الإفلاس عند خروج اللاعب.

### 🎲 2. نرد مونوبولي التفاعلي (Interactive Animated Dice Roller)
- رمي نرد متحرك يحاكي الوجه الحقيقي للنرد من 1 إلى 6.
- اكتشاف تلقائي للرميات الزوجية (Doubles!).
- نظام العقوبات التلقائي: عند الحصول على 3 رميات زوجية متتالية، يتم تحويل اللاعب للسجن فوراً وفق القواعد الرسمية.

### 🎴 3. كروت الحظ وصندوق الجماعة (Chance & Community Chest Cards)
- مجموعات كروت مخصصة لكل من كروت فرصة (Chance) وصندوق الجماعة (Community Chest).
- واجهة كروت جذابة مع إمكانية تطبيق تأثير الكارت (مكافأة، خصم، سجن، دفع للاعبين) مباشرة على اللاعبين بنقرة زر.

### 🕹️ 4. باقة الألعاب والتحديات المصغرة (14 Interactive Mini-Games)
نظام ألعاب مصغر متكامل لتحديد المكافآت والعقوبات النقدية أثناء اللعب، مقسم إلى 3 مستويات:

#### 🟢 المستوى السهل (Easy - 4 ألعاب):
1. **أتوبيس كومبليت السريع (Fast Stop the Bus)**: اذكر كلمات تبدأ بحرف محدد لـ 3 فئات قبل نفاد الوقت.
2. **تحدي القوافي (Rhyme Challenge)**: اذكر 3 كلمات على نفس الوزن والقافية.
3. **الكلمة المعكوسة (Short Reverse Word)**: اقرأ أو تهجأ الكلمة بالعكس من اليسار لليمين.
4. **الحساب السريع (Speed Math)**: حل العمليات الحسابية الذهنية السريعة مع خيارات متعددة.

#### 🟡 المستوى المتوسط (Medium - 5 ألعاب):
5. **البحث عن الحرف المشترك (Common Letter Finder)**: اكتشف الحرف المشترك الوحيد بين 4 كلمات.
6. **أسئلة عامة ومنطقية (Common Questions & Logic)**: أسئلة ذكاء وثقافة عامة وتفكير منطقي.
7. **سلسلة الحرف الأخير (Last Letter Word Chain)**: تكوين سلسلة كلمات تبدأ بالحرف الأخير من الكلمة السابقة.
8. **الكلمة الشاذة (Odd One Out)**: استخراج الكلمة التي لا تنتمي للمجموعة وتوضيح السبب.
9. **الكلمات المحظورة / تابو (Word Ban / Taboo)**: شرح الكلمة المستهدفة دون نطق أي من الكلمات المحظورة الخمس.

#### 🔴 المستوى الصعب (Hard - 5 ألعاب):
10. **الكلمة بشرطين (Double Constraint Word)**: ذكر كلمة تحقق قيدين محددين معاً (مثل تبدأ بحرف وتنتهي بآخر).
11. **تحديات اللياقة البدنية (Fitness Challenges)**: تنفيذ تمارين ضغط، قرفصاء، بلانك، وجامبينج جاكس في وقت محدد.
12. **أتوبيس كومبليت المتقدم (Hard Stop the Bus)**: 5 فئات متقدمة وصعبة تحت ضغط الوقت.
13. **تأثير ستروب - الألوان (Stroop Effect)**: اختبار التركيز المعرفي باختيار لون الحبر وتجاهل الكلمة المكتوبة.
14. **لويات اللسان (Tongue Twisters)**: تكرار الجمل الصعبة 3 مرات متتالية بسرعة ودون تلعثم.

### 📜 5. سجل العمليات والتدقيق (Transaction & Event Ledger)
- تسجيل زمني فوري لكل رمية نرد، تحويل مالي، مكافأة لعبة، أو عقوبة.
- إمكانية مراجعة السجل أو مسحه.

### 🎨 6. دعم كامل للعربية وواجهة مستجيبة (RTL, Dark/Light Themes & Responsive Layout)
- دعم كامل لاتجاه النص من اليمين لليسار (Arabic RTL).
- التبديل السلس بين الوضع الليلي الفاخر (Dark Theme) والوضع النهاري (Light Theme).
- واجهة مستجيبة تناسب الهواتف الذكية، الأجهزة اللوحية (Tablets)، وسطح المكتب (Desktop / Web) عبر Navigation Rail و Bottom Navigation Bar.

---

## 📂 الهيكل المعماري للمشروع (Project Architecture)

يتبع المشروع أسلوب **Clean Architecture / Feature-First Modular Structure**:

```text
monopoly_helper/
├── lib/
│   ├── main.dart                                # نقطة انطلاق التطبيق وتهيئة Providers
│   ├── app_navigation_shell.dart                # هيكل التنقل المستجيب (Navigation Shell)
│   ├── core/                                    # الثوابت، المظهر، الأدوات، والودجات العامة
│   │   ├── constants/
│   │   │   ├── app_colors.dart                  # ألوان المونوبولي والثيمات
│   │   │   ├── app_strings.dart                 # النصوص العربية والإنجليزية
│   │   │   ├── app_text_styles.dart             # أنماط الخطوط والطباعة
│   │   │   └── game_constants.dart              # مبالغ البداية، المؤقتات، والجوائز
│   │   ├── theme/
│   │   │   ├── app_theme.dart                   # إعدادات Material 3 Dark & Light
│   │   │   └── theme_provider.dart              # مزود حالة الثيم والاتجاه
│   │   ├── utils/
│   │   │   ├── timer_helper.dart                # متحكم المؤقت والعد التنازلي
│   │   │   ├── sound_helper.dart                # المؤثرات الصوتية والاهتزاز اللمسي
│   │   │   └── arabic_text_helper.dart          # معالجة وتطبيع النصوص العربية
│   │   └── widgets/
│   │       ├── custom_button.dart               # أزرار مخصصة
│   │       ├── custom_card.dart                 # كروت بتأثيرات بصرية
│   │       ├── game_timer_widget.dart           # مؤقت دائري ملون
│   │       ├── dice_widget.dart                 # نرد تفاعلي ثلاثي الأبعاد
│   │       ├── player_avatar.dart               # أفاتار اللاعبين وحالاتهم
│   │       ├── difficulty_badge.dart            # شارات مستويات الصعوبة
│   │       └── glass_container.dart             # حاوية بتأثير الزجاج المصنفر
│   ├── data/                                    # نماذج البيانات وقواعد البيانات
│   │   ├── models/
│   │   │   ├── player_model.dart                # كائن اللاعب
│   │   │   ├── transaction_model.dart           # كائن المعاملة المالية
│   │   │   ├── chance_card_model.dart           # كائن كارت الحظ
│   │   │   └── mini_game_result_model.dart      # كائن نتيجة اللعبة
│   │   └── datasets/                            # بنك الأسئلة والكلمات والتحديات
│   │       ├── stop_the_bus_data.dart           # بيانات أتوبيس كومبليت
│   │       ├── rhyme_data.dart                  # بيانات القوافي
│   │       ├── reverse_words_data.dart          # بيانات الكلمات المعكوسة
│   │       ├── speed_math_data.dart             # مولد مسائل الحساب السريع
│   │       ├── common_letter_data.dart          # بيانات الحرف المشترك
│   │       ├── trivia_questions_data.dart       # بنك الأسئلة العامة والمنطق
│   │       ├── word_chain_data.dart             # بيانات سلسلة الحروف
│   │       ├── odd_one_out_data.dart            # بيانات الكلمة الشاذة
│   │       ├── word_ban_data.dart               # كروت الكلمات المحظورة (تابو)
│   │       ├── double_constraint_data.dart      # بيانات تحدي الشرطين
│   │       ├── fitness_challenges_data.dart     # تمارين اللياقة البدنية
│   │       ├── stroop_effect_data.dart          # محفزات تأثير ستروب
│   │       ├── tongue_twisters_data.dart        # لويات اللسان
│   │       └── chance_community_cards_data.dart # كروت فرصة وصندوق الجماعة
│   └── features/                                # الميزات والواجهات
│       ├── dashboard/                           # لوحة التحكم الرئيسية والنرد
│       ├── player_management/                   # شاشات البنك، التحويل، وإدارة اللاعبين
│       ├── chance_community/                    # شاشة سحب كروت الحظ
│       ├── mini_games/                          # باقة الألعاب المصغرة
│       │   ├── core/                            # BaseMiniGame ومسير الألعاب
│       │   ├── easy/                            # كود الألعاب السهلة (4)
│       │   ├── medium/                          # كود الألعاب المتوسطة (5)
│       │   ├── hard/                            # كود الألعاب الصعبة (5)
│       │   └── presentation/                    # شاشة الردهة وشاشة تشغيل التحدي
│       ├── history/                             # شاشة سجل العمليات
│       └── settings/                            # شاشة الإعدادات
├── test/                                        # اختبارات الوحدة (Unit Tests)
│   ├── player_provider_test.dart
│   ├── mini_game_manager_test.dart
│   └── speed_math_test.dart
└── pubspec.yaml                                 # حزم واعتمادات المشروع
```

---

## 🚀 كيفية تشغيل المشروع وتطويره (Getting Started)

### 1. المتطلبات الأساسية
- تثبيت [Flutter SDK](https://flutter.dev/docs/get-started/install) (الإصدار 3.10 أو أحدث).
- بيئة تطوير متوافقة (VS Code أو Android Studio مع إضافات Flutter/Dart).

### 2. تثبيت الحزم
```bash
flutter pub get
```

### 3. تشغيل التطبيق
```bash
# للتشغيل على متصفح الويب (Chrome)
flutter run -d chrome

# للتشغيل على هاتف أندرويد أو محاكي
flutter run -d android

# للتشغيل على سطح المكتب (Windows / macOS / Linux)
flutter run -d windows
```

### 4. تشغيل اختبارات الوحدة (Tests)
```bash
flutter test
```

---

## 🔧 كيفية إضافة لعبة مصغرة جديدة (Extending with New Games)

لإضافة لعبة مصغرة جديدة إلى المشروع بسهولة:
1. أنشئ ملفاً جديداً في المجلد المناسب (`lib/features/mini_games/[easy|medium|hard]/your_game.dart`).
2. قم بالوراثة من الفئة المجردة `BaseMiniGame`:
```dart
class YourNewGame extends BaseMiniGame {
  YourNewGame() : super(
    id: 'your_game_id',
    title: 'عنوان اللعبة',
    description: 'وصف مختصر',
    rules: 'قواعد التحدي',
    difficulty: MiniGameDifficulty.easy, // أو medium أو hard
    timeLimitSeconds: 30,
    rewardAmount: 50,
    penaltyAmount: 20,
    icon: Icons.star,
  );

  @override
  void generateNewChallenge() {
    // تجهيز لغز أو تحدي عشوائي جديد
  }

  @override
  Widget buildChallengeWidget(BuildContext context, {required VoidCallback onGameWon, required VoidCallback onGameLost}) {
    // بناء واجهة اللعبة وأزرار النتيجة
    return YourCustomGameWidget(...);
  }
}
```
3. سجّل اللعبة الجديدة في `lib/features/mini_games/core/mini_game_manager.dart` داخل دالة `_registerGames()`.
