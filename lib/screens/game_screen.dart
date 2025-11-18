import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int level;
  late String levelLabel;
  int secondsElapsed = 0;
  Timer? timer;

  // --- TAMBAHAN 1: Variabel untuk menyimpan status inisialisasi ---
  bool _isInit = false;
  // --------------------------------------------------------------

  final List<int> solvedBoard = [
    5,
    3,
    4,
    6,
    7,
    8,
    9,
    1,
    2,
    6,
    7,
    2,
    1,
    9,
    5,
    3,
    4,
    8,
    1,
    9,
    8,
    3,
    4,
    2,
    5,
    6,
    7,
    8,
    5,
    9,
    7,
    6,
    1,
    4,
    2,
    3,
    4,
    2,
    6,
    8,
    5,
    3,
    7,
    9,
    1,
    7,
    1,
    3,
    9,
    2,
    4,
    8,
    5,
    6,
    9,
    6,
    1,
    5,
    3,
    7,
    2,
    8,
    4,
    2,
    8,
    7,
    4,
    1,
    9,
    6,
    3,
    5,
    3,
    4,
    5,
    2,
    8,
    6,
    1,
    7,
    9,
  ];

  late List<int?> currentBoard;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // --- PERBAIKAN DI SINI ---
    // Cek apakah sudah pernah di-init atau belum
    if (!_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      level = args['level'];
      levelLabel = args['label'];
      _initializeBoard();
      _startTimer();

      _isInit = true; // Tandai bahwa inisialisasi sudah selesai
    }
    // -------------------------
  }

  void _initializeBoard() {
    // Semakin tinggi level, semakin banyak angka dihapus
    int emptyCells =
        level * 10; // Contoh: Level 1 = 10 kosong, Level 5 = 50 kosong
    currentBoard = List.from(solvedBoard);

    for (int i = 0; i < emptyCells; i++) {
      // Logika random sederhana untuk menghapus sel
      currentBoard[(i * 7) % 81] = null;
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _checkWin() {
    if (!currentBoard.contains(null)) {
      bool isCorrect = true;
      for (int i = 0; i < 81; i++) {
        if (currentBoard[i] != solvedBoard[i]) isCorrect = false;
      }

      if (isCorrect) {
        timer?.cancel();
        Provider.of<GameProvider>(
          context,
          listen: false,
        ).saveScore(level, secondsElapsed);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Menang!"),
            content: Text("Waktu Anda: ${secondsElapsed} detik"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$levelLabel - Time: $secondsElapsed s")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                childAspectRatio: 1,
              ),
              itemCount: 81,
              itemBuilder: (ctx, index) {
                bool isPreFilled = currentBoard[index] != null;
                return GestureDetector(
                  onTap: isPreFilled ? null : () => _inputNumber(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      color: (index ~/ 9 ~/ 3 + index % 9 ~/ 3) % 2 == 0
                          ? Colors.grey[200]
                          : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        currentBoard[index]?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isPreFilled
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isPreFilled ? Colors.black : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _inputNumber(int index) async {
    int? number = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Pilih Angka"),
        children: List.generate(
          9,
          (i) => SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, i + 1),
            child: Text("${i + 1}", style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );

    if (number != null) {
      setState(() {
        currentBoard[index] = number;
      });
      _checkWin();
    }
  }
}
