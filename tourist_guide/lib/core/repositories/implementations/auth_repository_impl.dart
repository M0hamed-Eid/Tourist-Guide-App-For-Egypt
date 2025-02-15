import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firebase_auth_service.dart';
import '../interfaces/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return _authService.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  User? get currentUser => _authService.currentUser;
}