import 'dart:math';

class WordChainItem {
  final String startingWord;
  final int requiredChainLength;
  final String exampleChain;

  const WordChainItem({
    required this.startingWord,
    this.requiredChainLength = 4,
    required this.exampleChain,
  });
}

class WordChainData {
  WordChainData._();

  static const List<WordChainItem> items = [
    WordChainItem(
      startingWord: 'قطار',
      requiredChainLength: 4,
      exampleChain: 'قطار -> رمان -> نمر -> ريش',
    ),
    WordChainItem(
      startingWord: 'سحاب',
      requiredChainLength: 4,
      exampleChain: 'سحاب -> باب -> بحر -> رمل',
    ),
    WordChainItem(
      startingWord: 'مفتاح',
      requiredChainLength: 4,
      exampleChain: 'مفتاح -> حوت -> تفاح -> حصان',
    ),
    WordChainItem(
      startingWord: 'عصفور',
      requiredChainLength: 4,
      exampleChain: 'عصفور -> رمح -> حمار -> رعد',
    ),
    WordChainItem(
      startingWord: 'ليمون',
      requiredChainLength: 4,
      exampleChain: 'ليمون -> نخل -> ليل -> لسان',
    ),
  ];

  static WordChainItem getRandom() {
    final rand = Random();
    return items[rand.nextInt(items.length)];
  }
}
