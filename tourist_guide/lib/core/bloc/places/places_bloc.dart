
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/place.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final FirestoreService _firestoreService;
  final FirebaseAuthService _authService;

  PlacesBloc({
    required FirestoreService firestoreService,
    required FirebaseAuthService authService,
  })  : _firestoreService = firestoreService,
        _authService = authService,
        super(PlacesInitial()) {
    on<LoadAllPlaces>(_handleLoadAllPlaces);
    on<LoadSuggestedPlaces>(_handleLoadSuggestedPlaces);
    on<LoadPopularPlaces>(_handleLoadPopularPlaces);
    on<TogglePlaceFavorite>(_handleToggleFavorite);
  }

  Future<void> _handleLoadAllPlaces(
      LoadAllPlaces event,
      Emitter<PlacesState> emit,
      ) async {
    emit(PlacesLoading(isSuggestedLoading: true, isPopularLoading: true));

    try {
      final results = await Future.wait([
        _firestoreService.getPlacesByCategory('suggested'),
        _firestoreService.getPlacesByCategory('popular'),
      ]);

      final suggestedPlaces = results[0];
      final popularPlaces = results[1];

      // Get favorites if user is authenticated
      if (_authService.currentUser != null) {
        final favoriteIds = await _firestoreService.getFavorites(
          _authService.currentUser!.uid,
        );

        // Update isFavorite flag
        suggestedPlaces.forEach((place) {
          if (favoriteIds.contains(place.id)) {
            place = place.copyWith(isFavorite: true);
          }
        });

        popularPlaces.forEach((place) {
          if (favoriteIds.contains(place.id)) {
            place = place.copyWith(isFavorite: true);
          }
        });
      }

      emit(PlacesLoaded(
        suggestedPlaces: suggestedPlaces,
        popularPlaces: popularPlaces,
      ));
    } catch (e) {
      emit(PlacesError(
        e.toString(),
        isSuggestedError: true,
        isPopularError: true,
      ));
    }
  }

  Future<void> _handleLoadSuggestedPlaces(
      LoadSuggestedPlaces event,
      Emitter<PlacesState> emit,
      ) async {
    if (state is PlacesLoaded) {
      final currentState = state as PlacesLoaded;
      emit(PlacesLoading(isSuggestedLoading: true));

      try {
        final suggestedPlaces = await _firestoreService.getPlacesByCategory('suggested');
        emit(currentState.copyWith(suggestedPlaces: suggestedPlaces));
      } catch (e) {
        emit(PlacesError(e.toString(), isSuggestedError: true));
      }
    }
  }

  Future<void> _handleLoadPopularPlaces(
      LoadPopularPlaces event,
      Emitter<PlacesState> emit,
      ) async {
    if (state is PlacesLoaded) {
      final currentState = state as PlacesLoaded;
      emit(PlacesLoading(isPopularLoading: true));

      try {
        final popularPlaces = await _firestoreService.getPlacesByCategory('popular');
        emit(currentState.copyWith(popularPlaces: popularPlaces));
      } catch (e) {
        emit(PlacesError(e.toString(), isPopularError: true));
      }
    }
  }

  Future<void> _handleToggleFavorite(
      TogglePlaceFavorite event,
      Emitter<PlacesState> emit,
      ) async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to manage favorites');
      }

      await _firestoreService.toggleFavorite(user.uid, event.placeId);

      if (state is PlacesLoaded) {
        final currentState = state as PlacesLoaded;
        final favoriteIds = await _firestoreService.getFavorites(user.uid);

        final updatedSuggestedPlaces = currentState.suggestedPlaces
            .map((place) => place.copyWith(
          isFavorite: favoriteIds.contains(place.id),
        ))
            .toList();

        final updatedPopularPlaces = currentState.popularPlaces
            .map((place) => place.copyWith(
          isFavorite: favoriteIds.contains(place.id),
        ))
            .toList();

        final updatedFavoritePlaces = await _firestoreService.getPlacesByIds(favoriteIds);

        emit(currentState.copyWith(
          suggestedPlaces: updatedSuggestedPlaces,
          popularPlaces: updatedPopularPlaces,
          favoritePlaces: updatedFavoritePlaces,
        ));
      }
    } catch (e) {
      emit(PlacesError(e.toString()));
    }
  }
}