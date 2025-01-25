import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_themes.dart';

class AppTheme {
  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: AppColors.primary(isDark),
      scaffoldBackgroundColor: AppColors.background(isDark),
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColors.textPrimary(isDark),
        displayColor: AppColors.textPrimary(isDark),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary(isDark),
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.surface(isDark),
        ),
        titleTextStyle: TextStyle(
          color: AppColors.surface(isDark),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground(isDark),
        elevation: 4,
        shadowColor: AppColors.cardShadow(isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface(isDark),
        selectedItemColor: isDark ? AppColors.primaryLight(isDark) : AppColors.primary(isDark),
        unselectedItemColor: AppColors.textSecondary(isDark),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}