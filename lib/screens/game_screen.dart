// lib/screens/game_screen.dart

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
  int secondsElapsed = 0;
  Timer? timer;
  late Future<void> _gameInitializationFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // PENTING: Inisiasi Future HANYA jika _gameInitializationFuture belum diinisiasi.
    // Ini menggantikan _isInit = false yang rawan bug.
    if (!mounted || timer != null) return;

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final levelId = args['level'];
    final levelLabel = args['label'];

    final provider = Provider.of<GameProvider>(context, listen: false);

    // KUNCI: Panggil initGameData yang mengembalikan Future
    _gameInitializationFuture = provider.initGameData(levelId, levelLabel);

    // Timer dimulai setelah Future diinisiasi (tidak perlu menunggu Future selesai)
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => secondsElapsed++);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _handleInput(int index) async {
    int? number = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Pilih Angka"),
        children: List.generate(
          9,
          (i) => SimpleDialogOption(
            padding: const EdgeInsets.all(12),
            onPressed: () => Navigator.pop(ctx, i + 1),
            child: Center(
              child: Text("${i + 1}", style: const TextStyle(fontSize: 24)),
            ),
          ),
        ),
      ),
    );

    if (number != null) {
      final provider = Provider.of<GameProvider>(context, listen: false);
      provider.updateBoard(index, number);

      if (provider.checkWin()) {
        timer?.cancel();
        provider.saveScore(provider.currentLevel, secondsElapsed);
        _showWinDialog(provider.currentLevelLabel);
      }
    }
  }

  void _showWinDialog(String levelLabel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("MENANG!"),
        content: Text(
          "Anda menyelesaikan level $levelLabel dalam $secondsElapsed detik.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Kembali ke Home
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // KUNCI ANTI-BUG: FutureBuilder memastikan data siap
    return FutureBuilder(
      future: _gameInitializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Tampilkan loading saat papan sedang di-generate
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Setelah data siap, gunakan Consumer untuk mendengarkan perubahan state
        return Consumer<GameProvider>(
          builder: (context, gameData, child) {
            final levelLabel = gameData.currentLevelLabel;

            return Scaffold(
              appBar: AppBar(title: Text("$levelLabel - $secondsElapsed s")),
              body: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 9,
                            childAspectRatio: 1,
                          ),
                      itemCount: 81,
                      itemBuilder: (ctx, index) {
                        final value = gameData.currentBoard[index];
                        final isLocked = gameData.isLocked[index];

                        return GestureDetector(
                          onTap: isLocked ? null : () => _handleInput(index),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              color: (index ~/ 9 ~/ 3 + index % 9 ~/ 3) % 2 == 0
                                  ? Colors.grey[200]
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                value?.toString() ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: isLocked
                                      ? FontWeight.w900
                                      : FontWeight.normal,
                                  color: isLocked
                                      ? Colors.black
                                      : Colors.blue[800],
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
          },
        );
      },
    );
  }
}
