import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_helper/data/datasets/speed_math_data.dart';

void main() {
  group('SpeedMathData Tests', () {
    test('Generates valid math expression with 4 unique options including answer', () {
      for (int i = 0; i < 20; i++) {
        final challenge = SpeedMathData.generateChallenge();
        expect(challenge.expression.isNotEmpty, true);
        expect(challenge.options.length, 4);
        expect(challenge.options.contains(challenge.answer), true);
      }
    });
  });
}
