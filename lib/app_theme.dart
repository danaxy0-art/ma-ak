import 'package:flutter/material.dart';

/// Central place for the Ma'ak visual identity.
/// Colors are picked to match the provided mockups:
/// navy blue primary, warm off-white background, soft blue-grey accents.
class AppColors {
  static const Color primaryNavy = Color(0xFF2C4A66);
  static const Color primaryNavyDark = Color(0xFF1E3549);
  static const Color background = Color(0xFFF7F3EA);
  static const Color fieldFill = Color(0xFFFFFFFF);
  static const Color fieldBorder = Color(0xFFE1DCCF);
  static const Color textDark = Color(0xFF1E2A33);
  static const Color textMuted = Color(0xFF6B7480);
  static const Color selectedCardBorder = Color(0xFF6E93B5);
  static const Color selectedCardFill = Color(0xFFE9F0F6);
  static const Color divider = Color(0xFFE3DFD3);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primaryNavy,
        background: AppColors.background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDark),
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryNavy, width: 1.4),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.fieldBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
        ),
      ),
    );
  }
}
