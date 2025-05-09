import 'package:flutter/material.dart';

import 'Widgets/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Student Database Demo',
      home: HomeScreen(),
    );
  }
}