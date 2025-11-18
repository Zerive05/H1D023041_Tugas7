import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/app_drawer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Best Time Score")),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (ctx, i) {
          int level = i + 1;
          return ListTile(
            leading: CircleAvatar(child: Text("$level")),
            title: Text("Level $level"),
            trailing: Text(
              provider.getBestTime(level),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
