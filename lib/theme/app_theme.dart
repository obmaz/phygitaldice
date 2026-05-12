import 'package:flutter/material.dart';

class AppTheme {
  static const _ink = Color(0xFF151515);
  static const _paper = Color(0xFFF7F8F5);
  static const _panel = Color(0xFFFFFFFF);
  static const _teal = Color(0xFF168C78);
  static const _amber = Color(0xFFE2A536);
  static const _coral = Color(0xFFE35E4B);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: _teal,
            brightness: Brightness.light,
          ).copyWith(
            primary: _teal,
            secondary: _amber,
            tertiary: _coral,
            surface: _paper,
            onSurface: _ink,
          ),
      scaffoldBackgroundColor: _paper,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _panel,
        indicatorColor: _teal.withValues(alpha: 0.14),
      ),
    );
  }
}
