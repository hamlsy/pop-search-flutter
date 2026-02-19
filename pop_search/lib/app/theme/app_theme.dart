import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const background = Color(0xFFF4F6F3);
    const surface = Color(0xFFFFFFFF);
    const primary = Color(0xFF1F6A5A);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surface,
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData dark() {
    const background = Color(0xFF101513);
    const surface = Color(0xFF16201B);
    const primary = Color(0xFF8FD4BA);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surface,
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1D2B24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
