import 'dart:math';
import 'package:flutter/material.dart';

class StroopItem {
  final String textWord; // Word written (e.g. 'أحمر')
  final Color displayColor; // Color of the ink (e.g. Blue)
  final String colorNameArabic; // Name of the color of the ink (e.g. 'أزرق')
  final List<String> colorOptions;

  const StroopItem({
    required this.textWord,
    required this.displayColor,
    required this.colorNameArabic,
    required this.colorOptions,
  });
}

class StroopEffectData {
  StroopEffectData._();

  static const List<Map<String, dynamic>> _colorDefinitions = [
    {'name': 'أحمر', 'color': Color(0xFFE53935)},
    {'name': 'أزرق', 'color': Color(0xFF1E88E5)},
    {'name': 'أخضر', 'color': Color(0xFF43A047)},
    {'name': 'أصفر', 'color': Color(0xFFFDD835)},
    {'name': 'برتقالي', 'color': Color(0xFFFB8C00)},
    {'name': 'بنفسجي', 'color': Color(0xFF8E24AA)},
  ];

  static StroopItem generateChallenge() {
    final rand = Random();
    final textDef = _colorDefinitions[rand.nextInt(_colorDefinitions.length)];
    var inkDef = _colorDefinitions[rand.nextInt(_colorDefinitions.length)];
    // Ensure conflicting color
    while (inkDef['name'] == textDef['name']) {
      inkDef = _colorDefinitions[rand.nextInt(_colorDefinitions.length)];
    }

    final options = _colorDefinitions.map((e) => e['name'] as String).toList()..shuffle(rand);

    return StroopItem(
      textWord: textDef['name'] as String,
      displayColor: inkDef['color'] as Color,
      colorNameArabic: inkDef['name'] as String,
      colorOptions: options.take(4).contains(inkDef['name'])
          ? options.take(4).toList()
          : ([inkDef['name'] as String, ...options.where((x) => x != inkDef['name']).take(3)]..shuffle(rand)),
    );
  }
}
