import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_handleLogin);
    on<SignUpRequested>(_handleSignUp);
    on<LogoutRequested>(_handleLogout);
  }

  Future<void> _handleLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('email');
      final savedPassword = prefs.getString('password');

      if (event.email == savedEmail && event.password == savedPassword) {
        final user = User(
          name: prefs.getString('fullName') ?? '',
          email: savedEmail!,
          gender: prefs.getString('gender') ?? '',
          status: 'active',
        );
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', event.name);
      await prefs.setString('email', event.email);
      await prefs.setString('password', event.password);

      final user = User(
        name: event.name,
        email: event.email,
        gender: '',
        status: 'active',
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
