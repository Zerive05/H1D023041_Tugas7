// lib/utils/sudoku_generator.dart
import 'dart:math';

class SudokuGenerator {
  static List<int> generateSolvedBoard() {
    List<int> board = List.filled(81, 0);
    _fillBoard(board);
    return board;
  }

  static bool _fillBoard(List<int> board) {
    for (int i = 0; i < 81; i++) {
      if (board[i] == 0) {
        List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(Random());
        for (int num in nums) {
          if (_isValid(board, i, num)) {
            board[i] = num;
            if (_fillBoard(board)) return true;
            board[i] = 0;
          }
        }
        return false;
      }
    }
    return true;
  }

  static bool _isValid(List<int> board, int index, int num) {
    int row = index ~/ 9;
    int col = index % 9;
    for (int i = 0; i < 9; i++) {
      if (board[row * 9 + i] == num || board[i * 9 + col] == num) return false;
    }
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (board[(startRow + r) * 9 + (startCol + c)] == num) return false;
      }
    }
    return true;
  }
}
