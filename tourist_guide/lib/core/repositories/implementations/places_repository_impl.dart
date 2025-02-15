import '../../models/governorate.dart';
import '../../models/place.dart';
import '../../services/firestore_service.dart';
import '../interfaces/places_repository.dart';

class PlacesRepositoryImpl implements IPlacesRepository {
  final FirestoreService _firestoreService;

  PlacesRepositoryImpl(this._firestoreService);

  @override
  Future<List<Place>> getAllPlaces() async {
    try {
      return await _firestoreService.getAllPlaces();
    } catch (e) {
      throw Exception('Failed to get all places: $e');
    }
  }

  @override
  Future<List<Place>> getPlacesByCategory(String category) async {
    try {
      return await _firestoreService.getPlacesByCategory(category);
    } catch (e) {
      throw Exception('Failed to get places by category: $e');
    }
  }

  @override
  Future<Place?> getPlaceById(String placeId) async {
    try {
      return await _firestoreService.getPlaceById(placeId);
    } catch (e) {
      throw Exception('Failed to get place by ID: $e');
    }
  }

  @override
  Future<List<Place>> getPlacesByGovernorate(String governorateId) async {
    try {
      return await _firestoreService.getPlacesByGovernorate(governorateId);
    } catch (e) {
      throw Exception('Failed to get places by governorate: $e');
    }
  }

  @override
  Future<List<Governorate>> getAllGovernorates() async {
    try {
      return await _firestoreService.getAllGovernorates();
    } catch (e) {
      throw Exception('Failed to get all governorates: $e');
    }
  }

  @override
  Future<List<Place>> searchPlaces(String query) async {
    try {
      return await _firestoreService.searchPlaces(query);
    } catch (e) {
      throw Exception('Failed to search places: $e');
    }
  }

  @override
  Future<List<Place>> getPopularPlaces() async {
    try {
      return await _firestoreService.getPlacesByCategory('popular');
    } catch (e) {
      throw Exception('Failed to get popular places: $e');
    }
  }

  @override
  Future<List<Place>> getSuggestedPlaces() async {
    try {
      return await _firestoreService.getPlacesByCategory('suggested');
    } catch (e) {
      throw Exception('Failed to get suggested places: $e');
    }
  }

  @override
  Future<void> updatePlaceRating(String placeId, double rating) async {
    try {
      await _firestoreService.updatePlaceRating(placeId, rating);
    } catch (e) {
      throw Exception('Failed to update place rating: $e');
    }
  }

  @override
  Future<List<String>> getFavorites(String userId) async {
    try {
      return await _firestoreService.getFavorites(userId);
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String userId, String placeId) async {
    try {
      await _firestoreService.toggleFavorite(userId, placeId);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<List<Place>> getPlacesByIds(List<String> placeIds) async {
    try {
      if (placeIds.isEmpty) return [];
      return await _firestoreService.getPlacesByIds(placeIds);
    } catch (e) {
      throw Exception('Failed to get places by IDs: $e');
    }
  }
}
