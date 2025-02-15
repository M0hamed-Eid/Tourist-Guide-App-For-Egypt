import '../../models/user_profile.dart';
import '../../services/firestore_service.dart';
import '../interfaces/user_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  final FirestoreService _firestoreService;

  UserRepositoryImpl(this._firestoreService);

  @override
  Future<UserProfile?> getUserProfile(String uid) {
    return _firestoreService.getUserProfile(uid);
  }

  @override
  Future<void> saveUserProfile(String uid, UserProfile profile) {
    return _firestoreService.saveUserProfile(uid, profile);
  }

  @override
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) {
    return _firestoreService.updateUserProfile(uid, data);
  }
}