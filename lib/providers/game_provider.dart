// lib/providers/game_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/sudoku_generator.dart';
import 'dart:math';

class GameProvider with ChangeNotifier {
  // State Permainan
  List<int> _solutionBoard = [];
  List<int?> _currentBoard = [];
  List<bool> _isLocked = [];
  int _currentLevel = 0;
  String _currentLevelLabel = '';

  // State User/Auth
  String? _username;
  final Map<String, String> _bestTimes = {};

  // Getter
  String? get username => _username;
  List<int?> get currentBoard => _currentBoard;
  List<bool> get isLocked => _isLocked;
  int get currentLevel => _currentLevel;
  String get currentLevelLabel => _currentLevelLabel;

  // --- LOGIKA UTAMA GAME (Dipanggil dari HomeScreen) ---

  Future<void> initGameData(int level, String label) async {
    _currentLevel = level;
    _currentLevelLabel = label;
    _solutionBoard = SudokuGenerator.generateSolvedBoard();
    _currentBoard = List.from(_solutionBoard);
    _isLocked = List.filled(81, true);

    // Hapus Angka Sesuai Level
    int emptyCount = 10 + (level * 8);
    List<int> indices = List.generate(81, (i) => i)..shuffle(Random());

    for (int i = 0; i < emptyCount; i++) {
      int idx = indices[i];
      _currentBoard[idx] = null;
      _isLocked[idx] = false;
    }
    // Tidak panggil notifyListeners() karena UI akan menunggu Future ini selesai.
  }

  // Logika Input
  void updateBoard(int index, int number) {
    if (index >= 0 && index < 81 && !_isLocked[index]) {
      _currentBoard[index] = number;
      notifyListeners(); // KUNCI: Update UI di sini
    }
  }

  // Cek Menang
  bool checkWin() {
    if (_currentBoard.contains(null)) return false;
    for (int i = 0; i < 81; i++) {
      if (_currentBoard[i] != _solutionBoard[i]) return false;
    }
    return true;
  }

  // --- LOGIKA AUTH & SCORING (Sama seperti sebelumnya) ---

  Future<void> login(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user);
    _username = user;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
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

  String getBestTime(int level) => _bestTimes['Level $level'] ?? '-';

  Future<void> saveScore(int level, int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'best_time_$level';
    int? currentBest = prefs.getInt('${key}_int');

    if (currentBest == null || seconds < currentBest) {
      await prefs.setInt('${key}_int', seconds);
      await prefs.setString(key, _formatTime(seconds));
      _bestTimes['Level $level'] = _formatTime(seconds);
      notifyListeners();
    }
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
