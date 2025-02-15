import '../../models/user_profile.dart';

abstract class IUserRepository {
  Future<UserProfile?> getUserProfile(String uid);
  Future<void> saveUserProfile(String uid, UserProfile profile);
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data);
}