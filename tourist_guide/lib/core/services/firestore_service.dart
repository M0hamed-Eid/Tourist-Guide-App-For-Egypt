import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/governorate.dart';
import '../models/landmark.dart';
import '../models/place.dart';
import '../models/review.dart';
import '../models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _placesCollection =>
      _firestore.collection('places');

  CollectionReference<Map<String, dynamic>> get _governoratesCollection =>
      _firestore.collection('governorates');

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _reviewsCollection =>
      _firestore.collection('reviews');

  CollectionReference<Map<String, dynamic>> get _landmarksCollection =>
      _firestore.collection('landmarks');

  Future<Governorate?> getGovernorateById(String id) async {
    try {
      final doc = await _governoratesCollection.doc(id).get();
      if (!doc.exists) return null;

      return Governorate.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw Exception('Failed to get governorate by ID: $e');
    }
  }

  Future<List<Governorate>> searchGovernorates(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase();

      final snapshot = await _governoratesCollection
          .orderBy('nameKey')
          .startAt([lowercaseQuery])
          .endAt(['$lowercaseQuery\uf8ff'])
          .get();

      return snapshot.docs.map((doc) {
        return Governorate.fromJson({
          'id': doc.id,
          ...doc.data(),
        } );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search governorates: $e');
    }
  }

  Future<List<Place>> getAllPlaces() async {
    try {
      final snapshot = await _placesCollection
          .get();

      return snapshot.docs.map((doc) {
        return Place.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all places: $e');
    }
  }

  Future<Place?> getPlaceById(String placeId) async {
    try {
      final doc = await _placesCollection.doc(placeId).get();
      if (!doc.exists) return null;

      return Place.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw Exception('Failed to get place by ID: $e');
    }
  }

  Future<List<Place>> getPlacesByCategory(String category) async {
    try {
      final snapshot = await _placesCollection
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        return Place.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to get places by category: $e');
    }
  }

  Future<List<Governorate>> getAllGovernorates() async {
    try {
      final governoratesSnapshot = await _governoratesCollection.get();
      final List<Governorate> governorates = [];

      for (var governorateDoc in governoratesSnapshot.docs) {
        // Get landmarks for this governorate
        final landmarksSnapshot = await _landmarksCollection
            .where('governorateId', isEqualTo: governorateDoc.id)
            .get();

        final landmarks = landmarksSnapshot.docs
            .map((doc) => Landmark.fromJson({
          'id': doc.id,
          ...doc.data(),
        })).toList();

        governorates.add(Governorate.fromJson(
          {
            'id': governorateDoc.id,
            ...governorateDoc.data(),
          },
          landmarks,
        ));
      }

      return governorates;
    } catch (e) {
      throw Exception('Failed to get governorates: $e');
    }
  }

  Future<List<Landmark>> getLandmarksByGovernorate(String governorateId) async {
    try {
      final snapshot = await _landmarksCollection
          .where('governorateId', isEqualTo: governorateId)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Landmark.fromJson({
        'id': doc.id,
        ...doc.data(),
      }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get landmarks: $e');
    }
  }

  Future<void> updateLandmarkRating(String landmarkId, double rating) async {
    try {
      await _landmarksCollection.doc(landmarkId).update({
        'rating': rating,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update landmark rating: $e');
    }
  }

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

  Future<List<Place>> getPlacesByGovernorate(String governorateId) async {
    try {
      final snapshot = await _placesCollection
          .where('governorateId', isEqualTo: governorateId)
          .get();

      return snapshot.docs.map((doc) {
        return Place.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to get places by governorate: $e');
    }
  }

  Future<List<Place>> searchPlaces(String query) async {
    try {
      // Convert query to lowercase for case-insensitive search
      final lowercaseQuery = query.toLowerCase();

      final snapshot = await _placesCollection
          .orderBy('nameKey')
          .startAt([lowercaseQuery])
          .endAt(['$lowercaseQuery\uf8ff'])
          .get();

      return snapshot.docs.map((doc) {
        return Place.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to search places: $e');
    }
  }

  Future<void> updatePlaceRating(String placeId, double rating) async {
    try {
      final placeRef = _placesCollection.doc(placeId);

      await _firestore.runTransaction((transaction) async {
        final placeDoc = await transaction.get(placeRef);

        if (!placeDoc.exists) {
          throw Exception('Place not found');
        }

        final currentRating = placeDoc.data()?['rating'] ?? 0.0;
        final currentCount = placeDoc.data()?['ratingCount'] ?? 0;

        final newRating = ((currentRating * currentCount) + rating) / (currentCount + 1);
        final newCount = currentCount + 1;

        transaction.update(placeRef, {
          'rating': newRating,
          'ratingCount': newCount,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw Exception('Failed to update place rating: $e');
    }
  }

  Future<void> addReview(Review review) async {
    try {
      final batch = _firestore.batch();

      // Add review
      final reviewRef = _reviewsCollection.doc();
      batch.set(reviewRef, review.toJson());

      // Update place rating
      final placeRef = _placesCollection.doc(review.placeId);
      batch.update(placeRef, {
        'ratingCount': FieldValue.increment(1),
        'rating': FieldValue.increment(review.rating),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }


  // Favorites methods
  Future<void> toggleFavorite(String userId, String placeId) async {
    try {
      final userRef = _usersCollection.doc(userId);

      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        final favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);

        if (favorites.contains(placeId)) {
          favorites.remove(placeId);
        } else {
          favorites.add(placeId);
        }

        transaction.update(userRef, {
          'favorites': favorites,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  Future<List<String>> getFavorites(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      return List<String>.from(doc.data()?['favorites'] ?? []);
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  Future<List<Place>> getPlacesByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];

      // Firestore limits batches to 10 items, so we need to chunk the requests
      final chunks = <List<String>>[];
      for (var i = 0; i < ids.length; i += 10) {
        chunks.add(
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10),
        );
      }

      final results = await Future.wait(
        chunks.map((chunk) => _placesCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get()),
      );

      return results
          .expand((snapshot) => snapshot.docs)
          .map((doc) => Place.fromJson({
        'id': doc.id,
        ...doc.data(),
      }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get places by IDs: $e');
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