import 'package:flutter/material.dart';
import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/bloc/auth/auth_event.dart';
import '../../../core/singleton/app_state_singleton.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthBloc authBloc;
  final AppStateSingleton appState;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  LoginViewModel({
    required this.authBloc,
    required this.appState,
  });

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      authBloc.add(LoginRequested(
        email: email,
        password: password,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}