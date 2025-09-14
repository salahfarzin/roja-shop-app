import 'package:flutter/material.dart';
import 'screens/products/list.dart';

void main() {
  runApp(const ShoplonApp());
}

class ShoplonApp extends StatelessWidget {
  const ShoplonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roja Shop',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF181922),
        cardColor: const Color(0xFF23232B),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const ProductListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
