import '../../models/place.dart';
import '../../models/governorate.dart';

abstract class IPlacesRepository {
  Future<List<Place>> getAllPlaces();
  Future<List<Place>> getPlacesByCategory(String category);
  Future<Place?> getPlaceById(String placeId);
  Future<List<Place>> getPlacesByGovernorate(String governorateId);
  Future<List<Governorate>> getAllGovernorates();
  Future<List<Place>> searchPlaces(String query);
  Future<List<Place>> getPopularPlaces();
  Future<List<Place>> getSuggestedPlaces();
  Future<void> updatePlaceRating(String placeId, double rating);
  Future<List<String>> getFavorites(String userId);
  Future<void> toggleFavorite(String userId, String placeId);
  Future<List<Place>> getPlacesByIds(List<String> placeIds);
}