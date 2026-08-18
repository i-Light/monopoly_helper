class ArabicTextHelper {
  ArabicTextHelper._();

  static String normalize(String text) {
    var s = text.trim();
    // Remove diacritics / Tashkeel
    s = s.replaceAll(RegExp(r'[ً-ٰٟ]'), '');
    // Normalize Alef forms
    s = s.replaceAll(RegExp(r'[إأآٱ]'), 'ا');
    // Normalize Taa Marbuta
    s = s.replaceAll('ة', 'ه');
    // Normalize Yaa
    s = s.replaceAll('ى', 'ي');
    return s.toLowerCase();
  }

  static bool isMatch(String input, String expected) {
    return normalize(input) == normalize(expected);
  }

  static String reverseString(String s) {
    return s.split('').reversed.join('');
  }
}
