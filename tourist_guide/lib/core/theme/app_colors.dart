import 'package:flutter/material.dart';

class AppColors {
  static late bool _isDark;
  static final AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  AppColors._internal();

  static void initialize(bool isDark) {
    _isDark = isDark;
  }

  // Primary Colors
  static Color primary(bool isDark) => isDark ? const Color(0xFF42A5F5) : const Color(0xFF1976D2);
  static Color primaryDark(bool isDark) => isDark ? const Color(0xFF1565C0) : const Color(0xFF0D47A1);
  static Color primaryLight(bool isDark) => isDark ? const Color(0xFF64B5F6) : const Color(0xFF42A5F5);

  // Secondary Colors
  static Color secondary(bool isDark) => isDark ? const Color(0xFF26A69A) : const Color(0xFF00897B);
  static Color secondaryDark(bool isDark) => isDark ? const Color(0xFF00796B) : const Color(0xFF00695C);
  static Color secondaryLight(bool isDark) => isDark ? const Color(0xFF4DB6AC) : const Color(0xFF26A69A);

  // Background Colors
  static Color background(bool isDark) => isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
  static Color surface(bool isDark) => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  static Color cardBackground(bool isDark) => isDark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFFFF);
  static Color cardShadow(bool isDark) => isDark ? Colors.black54 : Colors.black12;

  // Text Colors
  static Color textPrimary(bool isDark) => isDark ? Colors.white : const Color(0xFF212121);
  static Color textSecondary(bool isDark) => isDark ? Colors.white70 : const Color(0xFF757575);
  static Color textLight(bool isDark) => isDark ? Colors.white38 : const Color(0xFFBDBDBD);

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);
  }