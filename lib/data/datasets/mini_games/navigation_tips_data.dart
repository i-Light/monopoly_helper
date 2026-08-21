/// Rotating hint strings shown on the pinned bottom navigation button.
///
/// Every time the currently-scrolling text fully leaves the screen, the
/// button picks a new random line from this list. Kept as a standalone
/// dataset (rather than inline in the widget) so new hints can be added
/// without touching any UI code.
class NavigationTipsData {
  NavigationTipsData._();

  static const List<String> tips = [
    'اضغط هنا لفتح قائمة التنقل والإعدادات',
    'يمكنك تعديل بيانات اللاعبين من قائمة التنقل قريباً',
    'كل ما زودت عدد الخطوات كل ما زاد التحدي صعوبة',
    'اضغط على شريط القواعد لقراءة تفاصيل التحدي كاملة',
    'يمكنك اختيار تحدي جديد يدوياً من زر "تحدي جديد"',
    'اللاعب النشط دايماً في منتصف الشريط العلوي',
    'لا اله الا الله',
    'سبحان الله الحمدلله الله أكبر',
    'سبحان الله وبحمده سبحان الله العظيم',
    'لا حول ولا قوة الا بالله'
  ];
}
