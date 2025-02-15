import 'package:flutter/material.dart';

import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/bloc/auth/auth_event.dart';
import '../../../core/singleton/app_state_singleton.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthBloc authBloc;
  final AppStateSingleton appState;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  SignUpViewModel({
    required this.authBloc,
    required this.appState,
  });

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      authBloc.add(SignUpRequested(
        name: name,
        email: email,
        password: password,
        phone: phone,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}