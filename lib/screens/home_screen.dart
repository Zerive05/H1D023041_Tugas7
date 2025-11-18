import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> levels = const [
    {'id': 1, 'label': 'Pemula', 'color': Colors.green},
    {'id': 2, 'label': 'Mudah', 'color': Colors.teal},
    {'id': 3, 'label': 'Normal', 'color': Colors.blue},
    {'id': 4, 'label': 'Susah', 'color': Colors.orange},
    {'id': 5, 'label': 'Profesional', 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Kesulitan")),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: levels.length,
          itemBuilder: (ctx, index) {
            return Card(
              color: levels[index]['color'],
              child: ListTile(
                title: Text(
                  levels[index]['label'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.play_arrow, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/game',
                    arguments: {
                      'level': levels[index]['id'],
                      'label': levels[index]['label'],
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
