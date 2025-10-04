import 'package:flutter/material.dart';

class AppTheme {
  static const Color seed = Color(0xFF4C643E); // اللون: 4C643E

  static ThemeData light({TextTheme? textTheme}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.white,        // ← أبيض للتطبيق كله
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,              // شريط علوي أبيض
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
