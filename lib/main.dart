import 'package:flutter/material.dart';

import 'screens/intropage.dart'; // Import Intropage

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Intropage(), // Start with Intropage
    );
  }
}
