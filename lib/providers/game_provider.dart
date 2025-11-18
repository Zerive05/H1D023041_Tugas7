import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider with ChangeNotifier {
  String? _username;
  Map<String, String> _bestTimes = {};

  String? get username => _username;

  // Fitur 1: User Auth (Simulasi & Local Storage)
  Future<void> login(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user);
    _username = user;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');

    // Load best times
    for (int i = 1; i <= 5; i++) {
      _bestTimes['Level $i'] = prefs.getString('best_time_$i') ?? '-';
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _username = null;
    notifyListeners();
  }

  // Fitur 4: Simpan Best Time Score
  Future<void> saveScore(int level, int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'best_time_$level';
    int? currentBest = prefs.getInt('${key}_int');

    if (currentBest == null || seconds < currentBest) {
      await prefs.setInt('${key}_int', seconds);
      await prefs.setString(key, formatTime(seconds));
      _bestTimes['Level $level'] = formatTime(seconds);
      notifyListeners();
    }
  }

  String getBestTime(int level) => _bestTimes['Level $level'] ?? '-';

  String formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
