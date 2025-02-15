import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class AppStateSingleton {
  static final AppStateSingleton _instance = AppStateSingleton._internal();

  factory AppStateSingleton() => _instance;

  AppStateSingleton._internal();

  // State variables
  UserProfile? currentUser;
  bool isDarkMode = false;
  String currentLanguage = 'en';
  final ValueNotifier<bool> authStateNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String> languageNotifier = ValueNotifier<String>('en');
  final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(false);

  // User methods
  void updateUser(UserProfile? user) {
    currentUser = user;
    authStateNotifier.value = user != null;
  }

  bool get isUserLoggedIn => currentUser != null;

  // Theme methods
  void updateTheme(bool isDark) {
    isDarkMode = isDark;
    themeNotifier.value = isDark;
  }

  // Language methods
  void updateLanguage(String language) {
    currentLanguage = language;
    languageNotifier.value = language;
  }

  // Clear all state (useful for logout)
  void clearState() {
    currentUser = null;
    authStateNotifier.value = false;
  }

  // Listen to state changes
  void addAuthStateListener(VoidCallback listener) {
    authStateNotifier.addListener(listener);
  }

  void removeAuthStateListener(VoidCallback listener) {
    authStateNotifier.removeListener(listener);
  }
}