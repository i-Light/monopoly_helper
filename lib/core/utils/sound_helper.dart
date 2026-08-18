import 'package:flutter/services.dart';

class SoundHelper {
  SoundHelper._();

  static bool isSoundEnabled = true;

  static void playRollDice() {
    if (!isSoundEnabled) return;
    HapticFeedback.mediumImpact();
  }

  static void playSuccess() {
    if (!isSoundEnabled) return;
    HapticFeedback.heavyImpact();
  }

  static void playFail() {
    if (!isSoundEnabled) return;
    HapticFeedback.vibrate();
  }

  static void playTick() {
    if (!isSoundEnabled) return;
    HapticFeedback.lightImpact();
  }
}
