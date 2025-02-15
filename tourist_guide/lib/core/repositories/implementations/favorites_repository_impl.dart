import '../../services/firestore_service.dart';
import '../interfaces/favorites_repository.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  final FirestoreService _firestoreService;

  FavoritesRepositoryImpl(this._firestoreService);

  @override
  Future<List<String>> getFavorites(String userId) {
    return _firestoreService.getFavorites(userId);
  }

  @override
  Future<void> toggleFavorite(String userId, String placeId) {
    return _firestoreService.toggleFavorite(userId, placeId);
  }
}