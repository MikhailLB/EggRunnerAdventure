import 'package:flutter/material.dart';

/// Warm, storybook-inspired palette. Every screen shares the same values so
/// the app feels consistent from boot to codex.
class AppColors {
  static const Color sunrise = Color(0xFFFFB94D);
  static const Color yolk = Color(0xFFFFCB47);
  static const Color meadow = Color(0xFF4CAF7B);
  static const Color sky = Color(0xFF3BA9E0);
  static const Color rust = Color(0xFFD64545);
  static const Color parchment = Color(0xFFFFF6E1);
  static const Color ink = Color(0xFF2A1A0E);
  static const Color muted = Color(0xFF806A5A);
  static const Color card = Color(0xFFFFFDF6);
  static const Color divider = Color(0xFFE9DCC0);
}

ThemeData buildAppTheme() {
  const seed = AppColors.rust;
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      primary: AppColors.rust,
      secondary: AppColors.sunrise,
      surface: AppColors.parchment,
    ),
    scaffoldBackgroundColor: AppColors.parchment,
    fontFamily: 'Baloo2',
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: AppColors.ink,
      titleTextStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: 'Baloo2',
      ),
      iconTheme: IconThemeData(color: AppColors.ink),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w800,
      ),
      displaySmall: TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.ink, height: 1.5, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.ink, height: 1.45),
      bodySmall: TextStyle(color: AppColors.muted),
      labelLarge: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
    ),
    dividerColor: AppColors.divider,
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.rust,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.rust, width: 1.6),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
  return base;
}
