import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const OmokApp());
}

class OmokApp extends StatelessWidget {
  const OmokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오목',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(), // 첫 화면 → 난이도 선택
    );
  }
}