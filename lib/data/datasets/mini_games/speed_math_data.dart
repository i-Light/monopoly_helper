import 'dart:math';

class MathChallenge {
  final String expression;
  final int answer;
  final List<int> options;

  const MathChallenge({
    required this.expression,
    required this.answer,
    required this.options,
  });
}

class SpeedMathData {
  SpeedMathData._();

  static MathChallenge generateChallenge() {
    final rand = Random();
    final opType = rand.nextInt(4); // 0: +, 1: -, 2: *, 3: mixed
    int a, b, answer;
    String expression;

    switch (opType) {
      case 0: // Addition
        a = rand.nextInt(45) + 12;
        b = rand.nextInt(45) + 8;
        answer = a + b;
        expression = '$a + $b = ?';
        break;
      case 1: // Subtraction
        a = rand.nextInt(60) + 25;
        b = rand.nextInt(a - 5) + 4;
        answer = a - b;
        expression = '$a - $b = ?';
        break;
      case 2: // Multiplication
        a = rand.nextInt(11) + 3;
        b = rand.nextInt(11) + 3;
        answer = a * b;
        expression = '$a × $b = ?';
        break;
      case 3: // Mixed: (a * b) + c
      default:
        a = rand.nextInt(8) + 2;
        b = rand.nextInt(7) + 2;
        final c = rand.nextInt(20) + 5;
        answer = (a * b) + c;
        expression = '($a × $b) + $c = ?';
        break;
    }

    final optionsSet = <int>{answer};
    while (optionsSet.length < 4) {
      final offset = rand.nextInt(15) + 1;
      final wrong = rand.nextBool() ? answer + offset : answer - offset;
      if (wrong >= 0) optionsSet.add(wrong);
    }

    final optionsList = optionsSet.toList()..shuffle(rand);

    return MathChallenge(
      expression: expression,
      answer: answer,
      options: optionsList,
    );
  }
}
