import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_profile.dart';
import 'auth_event.dart';
import 'auth_state.dart';

import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  final FirestoreService firestoreService;

  AuthBloc({
    required this.authService,
    required this.firestoreService,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_handleLogin);
    on<SignUpRequested>(_handleSignUp);
    on<LogoutRequested>(_handleLogout);
  }

  Future<void> _handleLogin(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await authService.signInWithEmailAndPassword(
        event.email,
        event.password,
      );

      final userProfile = await firestoreService.getUserProfile(
        userCredential.user!.uid,
      );

      if (userProfile != null) {
        emit(AuthAuthenticated(userProfile));
      } else {
        emit(const AuthError('User profile not found'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> _handleSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await authService.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );

      final now = DateTime.now();
      final userProfile = UserProfile(
        id: userCredential.user!.uid,
        name: event.name,
        email: event.email,
        phone: event.phone,
        hashedPassword: '', // Password is handled by Firebase Auth
        createdAt: now,
        updatedAt: now,
      );

      await firestoreService.saveUserProfile(
        userCredential.user!.uid,
        userProfile,
      );

      emit(AuthAuthenticated(userProfile));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleLogout(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
