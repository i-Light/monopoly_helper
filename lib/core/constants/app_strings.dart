/// Centralized, human-readable copy for the whole app.
///
/// Every user-facing piece of text lives here (rather than inline in
/// widgets) so wording can be reviewed or swapped in one place. Strings
/// carried over from the previous version of the app were left untouched;
/// only new strings needed for the redesigned turn flow were added.
class AppStrings {
  AppStrings._();

  // App Identity
  static const String appTitle = 'بنك وقرشين';
  static const String appSubtitle = 'باقة الألعاب المصغرة والتحديات التفاعلية';

  // Difficulties
  static const String allDifficulties = 'الكل';
  static const String easy = 'سهل';
  static const String medium = 'متوسط';
  static const String hard = 'صعب';

  // Game Controls & Actions
  static const String randomGame = 'اختيار لعبة عشوائية';
  static const String startTimer = 'بدء المؤقت';
  static const String pauseTimer = 'إيقاف مؤقت';
  static const String resetTimer = 'إعادة ضبط المؤقت';
  static const String newChallenge = 'تحدي جديد';
  static const String revealAnswer = '👁️ كشف الإجابة / الحل';
  static const String hideAnswer = 'إخفاء الإجابة';
  static const String markSuccess = 'تم أو ادفع 💰';
  static const String markFail = 'ما تتحركش';
  static const String timeUp = '⏰ انتهى الوقت!';
  static const String seconds = 'ثانية';
  static const String rules = 'قواعد التحدي';
  static const String score = 'النقاط / مرات الفوز';
  static const String totalPlayed = 'إجمالي التحديات';
  static const String selectGame = 'اختر لعبة من القائمة لبدء التحدي';

  // ---------------------------------------------------------------------
  // Moves-selection stage (screen 1 of the main turn loop)
  // ---------------------------------------------------------------------
  static const String movesSelectionPrompt =
      'اختر عدد الخطوات اللي عايز تلعبها. كل ما زودت عدد الخطوات كل ما كان '
      'التحدي أصعب، والمبلغ اللي هتدفعه لو خسرت وقررت تتحرك برضه هيكون أكبر.';
  static const String stepsLabel = 'خطوة';

  // ---------------------------------------------------------------------
  // Challenge (games) stage (screen 2 of the main turn loop)
  // ---------------------------------------------------------------------
  static const String rulesBannerPrefix = 'القواعد';
  static const String dontMove = 'لا تتحرك';
  static const String confirmAndContinue = 'تم، التالي';
  static const String payToMovePrefix = 'ادفع';
  static const String payToMoveSuffix = 'وتحرك';
  static const String currency = '£';

  // Pay confirmation sheet
  static const String payConfirmTitle = 'تأكيد الدفع';
  static const String payConfirmBody =
      'هل أنت متأكد أنك عايز تدفع المبلغ ده عشان تكمل حركتك رغم خسارة التحدي؟';
  static const String payConfirmAccept = 'أيوه، ادفع وكمل';
  static const String payConfirmCancel = 'إلغاء';

  // ---------------------------------------------------------------------
  // Results stage (screen 3 of the main turn loop)
  // ---------------------------------------------------------------------
  static const String resultWonHeadline = 'فزت بالتحدي! تحرك مجاناً 🎉';
  static const String resultPaidHeadline =
      'خسرت التحدي، بس دفعت وكملت الحركة 💰';
  static const String resultStayedHeadline = 'خسرت التحدي وقررت تفضل مكانك';
  static const String goToCityPrefix = 'روح';
  static const String stayAtCityPrefix = 'ابق في';
  static const String colorOnCardTooltip = 'اللون على الكارت';
  static const String colorOnBoardTooltip = 'اللون على اللوحة';

  static const String buyCity = 'شراء';
  static const String citySold = 'تم الشراء';
  static const String buyGarage = 'شراء الجراج';
  static const String garageSold = 'تم شراء الجراج';
  static const String buyMarket = 'شراء السوق';
  static const String marketSold = 'تم شراء السوق';
  static const String endTurn = 'أنهى الدور';

  static const String buyFromOwner = 'اشترها منه';
  static const String payOwnerAndFinish = 'ادفع له وأنهي الدور';

  static const String insufficientFunds = 'الرصيد مش كافي لإتمام العملية';

  // ---------------------------------------------------------------------
  // Special tiles: Start / Express Bus / Club / Prison
  // ---------------------------------------------------------------------
  static const String passthroughStartMessage =
      'وصلت البداية، معدي بس، مفيش شراء هنا.';
  static const String passthroughExpressBusMessage =
      'ركبت الأوتوبيس السريع، معدي بس.';
  static const String passthroughPrisonVisitMessage =
      'زرت السجن بس مش متسجن، معدي بس.';

  static const String clubSubscribeLabel = 'اشترك في النادي';
  static const String clubAlreadyMember = 'أنت عضو بالفعل';
  static const String clubFull = 'النادي مكتمل أدفع 30£ للبنك';

  static const String prisonArrestButtonLabel =
      'مش معايا فلوس كفاية، روح السجن';
  static const String prisonChoiceHeadline = 'أنت في السجن!';
  static const String prisonAttemptEscapeLabel = 'حاول تهرب (تحدي صعب)';
  static const String prisonPayBailLabel = 'ادفع الكفالة';
  static const String prisonEscapeWonHeadline = 'هربت من السجن! 🎉';
  static const String prisonEscapeLostHeadline = 'فشلت في الهروب، لسه في السجن';

  // ---------------------------------------------------------------------
  // Player status bar
  // ---------------------------------------------------------------------
  static const String playerPositionUnknown = 'لسه ما اتحركش';

  // ---------------------------------------------------------------------
  // Navigation drawer (opened from the pinned bottom button)
  // ---------------------------------------------------------------------
  static const String navigationDrawerTitle = 'التنقل';
  static const String navigationDrawerComingSoon =
      'الإعدادات وتعديل كروت اللاعبين هتتضاف هنا قريباً.';

  // Rotating hint strings shown on the pinned bottom marquee button.
  // Sourced from NavigationTipsData so they stay editable in one dataset.
  static const String openNavigation = 'افتح قائمة التنقل';

  // ---------------------------------------------------------------------
  // Challenge picker (the "new challenge" filterable list)
  // ---------------------------------------------------------------------
  static const String challengePickerTitle = 'اختر تحدي';
  static const String noGamesForFilter = 'لا توجد ألعاب لهذا التصنيف';

  // ---------------------------------------------------------------------
  // 14 Mini Games Strings (unchanged from the original app)
  // ---------------------------------------------------------------------
  // Easy
  static const String gameFastStopBusTitle = 'أتوبيس كومبليت السريع';
  static const String gameFastStopBusDesc =
      'اذكر كلمات تبدأ بحرف محدد لـ 3 فئات قبل نفاد الوقت!';

  static const String gameRhymeChallengeTitle = 'تحدي القوافي';
  static const String gameRhymeChallengeDesc =
      'اذكر 3 كلمات على نفس الوزن والقافية مع الكلمة المحددة!';

  static const String gameShortReverseWordTitle = 'الكلمة المعكوسة';
  static const String gameShortReverseWordDesc =
      'اقرأ أو تهجأ الكلمة من اليسار لليمين بالعكس بدقة وسرعة!';

  static const String gameSpeedMathTitle = 'الحساب السريع';
  static const String gameSpeedMathDesc =
      'حل العمليات الحسابية الذهنية السريعة في وقت قياسي!';

  // Medium
  static const String gameCommonLetterTitle = 'البحث عن الحرف المشترك';
  static const String gameCommonLetterDesc =
      'اكتشف الحرف المشترك الوحيد المتكرر في جميع الكلمات المعروضة!';

  static const String gameTriviaLogicTitle = 'أسئلة عامة ومنطقية';
  static const String gameTriviaLogicDesc =
      'أجب عن سؤال ذكاء، ثقافة عامة، أو لغز منطقي مع خيارات متعددة!';

  static const String gameWordChainTitle = 'سلسلة الحرف الأخير';
  static const String gameWordChainDesc =
      'كوّن سلسلة كلمات حيث تبدأ كل كلمة بالحرف الأخير من الكلمة السابقة!';

  static const String gameOddOneOutTitle = 'الكلمة الشاذة';
  static const String gameOddOneOutDesc =
      'حدد العنصر الذي لا ينتمي للمجموعة واشرح السبب!';

  static const String gameWordBanTitle = 'الكلمات المحظورة (تابو)';
  static const String gameWordBanDesc =
      'اشرح الكلمة المطلوبة للاعبين دون نطق أي من الكلمات المحظورة الخمس!';

  // Hard
  static const String gameDoubleConstraintTitle = 'الكلمة بشرطين';
  static const String gameDoubleConstraintDesc =
      'اذكر كلمة تحقق شرطين محددين معاً (مثل تبدأ بحرف س وتنتهي بحرف ل)!';

  static const String gameFitnessChallengesTitle = 'تحديات اللياقة البدنية';
  static const String gameFitnessChallengesDesc =
      'قم بتنفيذ تمارين بدنية ممتعة مثل الضغط أو القرفصاء في الوقت المحدد!';

  static const String gameHardStopBusTitle = 'أتوبيس كومبليت المتقدم';
  static const String gameHardStopBusDesc =
      'تحدي أتوبيس كومبليت موسع بـ 5 فئات صعبة وقيود دقيقة!';

  static const String gameStroopEffectTitle = 'تأثير ستروب (الألوان)';
  static const String gameStroopEffectDesc =
      'انطق أو اختر لون الحبر الذي كُتبت به الكلمة وتجاهل الكلمة نفسها!';

  static const String gameTongueTwistersTitle = 'لويات اللسان';
  static const String gameTongueTwistersDesc =
      'كرر العبارة الصعبة 3 مرات متتالية بسرعة ودون أي تلعثم!';
}
