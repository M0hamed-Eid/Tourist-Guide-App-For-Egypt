import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_profile.dart';
import '../../repositories/interfaces/auth_repository.dart';
import '../../repositories/interfaces/user_repository.dart';
import '../../singleton/app_state_singleton.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;
  final AppStateSingleton _appState = AppStateSingleton();

  AuthBloc({
    required IAuthRepository authRepository,
    required IUserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_handleLogin);
    on<SignUpRequested>(_handleSignUp);
    on<LogoutRequested>(_handleLogout);
  }

  Future<void> _handleLogin(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );

      final userProfile = await _userRepository.getUserProfile(
        userCredential.user!.uid,
      );

      if (userProfile != null) {
        _appState.updateUser(userProfile); // Update singleton
        emit(AuthAuthenticated(userProfile));
      } else {
        emit(const AuthError('User profile not found'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleSignUp(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential =
          await _authRepository.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );

      final now = DateTime.now();
      final userProfile = UserProfile(
        id: userCredential.user!.uid,
        name: event.name,
        email: event.email,
        phone: event.phone,
        hashedPassword: '',
        // Password is handled by Firebase Auth
        createdAt: now,
        updatedAt: now,
      );

      await _userRepository.saveUserProfile(
        userCredential.user!.uid,
        userProfile,
      );

      emit(AuthAuthenticated(userProfile));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleLogout(
      LogoutRequested event,
      Emitter<AuthState> emit)
  async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      _appState.clearState(); // Clear singleton state
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
