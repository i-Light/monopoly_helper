import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    fontFamily: 'Cairo',
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    fontFamily: 'Cairo',
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: 'Cairo',
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Cairo',
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    fontFamily: 'Cairo',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    fontFamily: 'Cairo',
  );

  static const TextStyle cashDisplay = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.cashGold,
    letterSpacing: 0.5,
    fontFamily: 'Cairo',
  );

  static const TextStyle timerText = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.0,
  );
}
