import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';

class SettingsProvider extends ChangeNotifier {
  int _startingCash = GameConstants.defaultStartingCash;
  int _goSalary = GameConstants.goSalary;
  int _jailBail = GameConstants.jailBailCost;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  int get startingCash => _startingCash;
  int get goSalary => _goSalary;
  int get jailBail => _jailBail;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  void updateRules({int? startingCash, int? goSalary, int? jailBail}) {
    if (startingCash != null) _startingCash = startingCash;
    if (goSalary != null) _goSalary = goSalary;
    if (jailBail != null) _jailBail = jailBail;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    notifyListeners();
  }
}
