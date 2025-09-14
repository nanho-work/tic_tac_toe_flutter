import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startGame(BuildContext context, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(difficulty: difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오목 - 난이도 선택')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _startGame(context, 'easy'),
              child: const Text('쉬움'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startGame(context, 'normal'),
              child: const Text('보통'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startGame(context, 'hard'),
              child: const Text('어려움'),
            ),
          ],
        ),
      ),
    );
  }
}