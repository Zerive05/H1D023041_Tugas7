import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final gameProvider = GameProvider();
  await gameProvider.loadUserData();

  runApp(
    ChangeNotifierProvider(create: (_) => gameProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GameProvider>(context).username;

    return MaterialApp(
      title: 'Sudoku by Zerive05',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      // Implementasi Routes
      initialRoute: user == null ? '/login' : '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}
