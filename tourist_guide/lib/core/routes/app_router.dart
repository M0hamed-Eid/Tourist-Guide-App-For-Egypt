import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/auth/signup/signup_page.dart';
import '../../screens/auth/login/login_page.dart';
import '../../screens/governments/landmarks/landmarks_page.dart';
import '../../screens/main_layout.dart';
import '../../screens/profile/profile_page.dart';
import '../models/governorate.dart';
import '../theme/app_colors.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        switch (settings.name) {
          case login:
            return const LoginPage();

          case signup:
            return const SignUpPage();

          case main:
            return const MainLayout();

          case profile:
            return const ProfilePage();

          case landmarks:
            if (settings.arguments is Governorate) {
              return LandmarksPage(
                governorate: settings.arguments as Governorate,
              );
            }
            return _errorRoute('Missing governorate data');

          default:
            return _errorRoute('No route defined for ${settings.name}');
        }
      },
    );
  }

  static Widget _errorRoute(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Route names
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String landmarks = '/landmarks';
}