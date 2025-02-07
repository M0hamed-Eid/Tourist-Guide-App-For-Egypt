import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/auth/signup/signup_page.dart';
import '../../screens/auth/login/login_page.dart';
import '../../screens/governments/landmarks/landmarks_page.dart';
import '../../screens/main_layout.dart';
import '../models/governorate.dart';
import '../theme/app_colors.dart';
import 'route_transitions.dart';

class AppRouter {

  static const String signup = '/signup';
  static const String login = '/login';
  static const String landmarks = '/landmarks';
  static const String main = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signup:
        return RouteTransitions.fadeTransition(const SignUpPage());

      case login:
        return RouteTransitions.fadeTransition(LoginPage());

      case main:
        return MaterialPageRoute(
          builder: (_) => const MainLayout(),
          settings: settings,
        );

      case landmarks:
        if (settings.arguments is Governorate) {
          return RouteTransitions.fadeTransition(
            LandmarksPage(governorate: settings.arguments as Governorate),
          );
        }
        return _errorRoute('Missing governorate data');

      case '/':
        return RouteTransitions.fadeTransition(MainLayout());

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
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
      ),
    );
  }
}
