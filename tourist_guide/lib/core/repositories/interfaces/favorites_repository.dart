abstract class IFavoritesRepository {
  Future<List<String>> getFavorites(String userId);
  Future<void> toggleFavorite(String userId, String placeId);
}