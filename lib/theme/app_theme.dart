import 'package:flutter/material.dart';

class AppColors {
  static const canvas = Color(0xFFFBF9F4);
  static const forest = Color(0xFF183922);
  static const forestDark = Color(0xFF00210D);
  static const green = Color(0xFF446747);
  static const mutedGreen = Color(0xFF7FA385);
  static const paleGreen = Color(0xFFC6ECCA);
  static const gold = Color(0xFFC79D4C);
  static const sand = Color(0xFFEFE8DA);
  static const text = Color(0xFF243329);
  static const muted = Color(0xFF727971);
  static const line = Color(0xFFE8E4DA);
  static const white = Colors.white;
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        primary: AppColors.forest,
        secondary: AppColors.gold,
        surface: AppColors.canvas,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.text, fontSize: 14),
        bodyMedium: TextStyle(color: AppColors.text, fontSize: 12),
        labelLarge: TextStyle(
          color: AppColors.forestDark,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerColor: AppColors.line,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
