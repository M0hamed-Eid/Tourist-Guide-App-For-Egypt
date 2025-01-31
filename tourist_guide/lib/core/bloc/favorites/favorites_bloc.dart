import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/place.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FirebaseAuthService authService;
  final FirestoreService firestoreService;

  FavoritesBloc({
    required this.authService,
    required this.firestoreService,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_handleLoadFavorites);
    on<ToggleFavorite>(_handleToggleFavorite);
  }

  Future<void> _handleLoadFavorites(
      LoadFavorites event,
      Emitter<FavoritesState> emit,
      ) async {
    emit(FavoritesLoading());
    try {
      final user = authService.currentUser;
      if (user != null) {
        final favoriteIds = await firestoreService.getFavorites(user.uid);
        final favoritePlaces = AppConstants.allPlaces
            .where((place) => favoriteIds.contains(place.id))
            .toList();
        emit(FavoritesLoaded(places: favoritePlaces));
      } else {
        emit(FavoritesError('User not authenticated'));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _handleToggleFavorite(
      ToggleFavorite event,
      Emitter<FavoritesState> emit,
      ) async {
    try {
      final user = authService.currentUser;
      if (user == null) {
        emit(FavoritesError('User not authenticated'));
        return;
      }

      // Get current state
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        // Optimistically update UI
        final isCurrentlyFavorite = currentState.places.any((p) => p.id == event.placeId);
        final updatedPlaces = isCurrentlyFavorite
            ? currentState.places.where((p) => p.id != event.placeId).toList()
            : [...currentState.places, AppConstants.allPlaces.firstWhere((p) => p.id == event.placeId)];

        emit(FavoritesLoaded(places: updatedPlaces));

        // Update in Firestore
        await firestoreService.toggleFavorite(user.uid, event.placeId);
      }

      // Reload favorites to ensure consistency
      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(e.toString()));
      // Reload favorites to ensure UI is in sync
      add(LoadFavorites());
    }
  }
}