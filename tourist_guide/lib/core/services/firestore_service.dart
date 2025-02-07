
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/place.dart';
import '../models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;


  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return UserProfile.fromJson({
        'id': docSnapshot.id,
        ...docSnapshot.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Save user profile
  Future<void> saveUserProfile(String userId, UserProfile profile) async {
    try {
      await _usersCollection.doc(userId).set(
        profile.toJson()..remove('id'), // Remove ID as it's the document ID
        SetOptions(merge: true), // Merge with existing data if any
      );
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  // Check if user exists
  Future<bool> userExists(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();
      return docSnapshot.exists;
    } catch (e) {
      throw Exception('Failed to check user existence: $e');
    }
  }
  Future<List<Place>> getPlacesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('places')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) => Place.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load $category places: $e');
    }
  }

  Future<List<String>> getFavorites(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return List<String>.from(doc.data()?['favorites'] ?? []);
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<List<Place>> getPlacesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      final snapshot = await _firestore
          .collection('places')
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      return snapshot.docs
          .map((doc) => Place.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load places by ids: $e');
    }
  }

  Future<void> toggleFavorite(String userId, String placeId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        final favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);

        if (favorites.contains(placeId)) {
          favorites.remove(placeId);
        } else {
          favorites.add(placeId);
        }

        transaction.update(userRef, {'favorites': favorites});
      });
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  Future<void> updateUserAvatar(String userId, String? avatarUrl) async {
    try {
      await _usersCollection.doc(userId).update({
        'avatarUrl': avatarUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update avatar: $e');
    }
  }

}