
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
    if (state is PlacesLoading) return;

    emit(PlacesLoading(isSuggestedLoading: true, isPopularLoading: true));

    try {
      // Explicitly type the results
      List<dynamic> results;
      if (_authService.currentUser != null) {
        results = await Future.wait<dynamic>([
          _firestoreService.getPlacesByCategory('suggested'),
          _firestoreService.getPlacesByCategory('popular'),
          _firestoreService.getFavorites(_authService.currentUser!.uid),
        ]);
      } else {
        results = await Future.wait<List<Place>>([
          _firestoreService.getPlacesByCategory('suggested'),
          _firestoreService.getPlacesByCategory('popular'),
        ]);
      }

      final List<Place> suggestedPlaces = results[0] as List<Place>;
      final List<Place> popularPlaces = results[1] as List<Place>;
      final List<String> favoriteIds = _authService.currentUser != null
          ? (results[2] as List<String>)
          : <String>[];

      emit(PlacesLoaded(
        suggestedPlaces: suggestedPlaces,
        popularPlaces: popularPlaces,
        favoriteIds: favoriteIds,
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
    if (state is! PlacesLoaded) return;
    final currentState = state as PlacesLoaded;

    emit(PlacesLoading(isSuggestedLoading: true));

    try {
      final suggestedPlaces = await _firestoreService.getPlacesByCategory('suggested');
      emit(currentState.copyWith(suggestedPlaces: suggestedPlaces));
    } catch (e) {
      emit(PlacesError(e.toString(), isSuggestedError: true));
    }
  }

  Future<void> _handleLoadPopularPlaces(
      LoadPopularPlaces event,
      Emitter<PlacesState> emit,
      ) async {
    if (state is! PlacesLoaded) return;
    final currentState = state as PlacesLoaded;

    emit(PlacesLoading(isPopularLoading: true));

    try {
      final popularPlaces = await _firestoreService.getPlacesByCategory('popular');
      emit(currentState.copyWith(popularPlaces: popularPlaces));
    } catch (e) {
      emit(PlacesError(e.toString(), isPopularError: true));
    }
  }

  Future<void> _handleToggleFavorite(
      TogglePlaceFavorite event,
      Emitter<PlacesState> emit,
      ) async {
    if (state is! PlacesLoaded) return;
    final currentState = state as PlacesLoaded;

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to manage favorites');
      }

      // Optimistically update UI
      final updatedFavoriteIds = List<String>.from(currentState.favoriteIds);
      if (updatedFavoriteIds.contains(event.placeId)) {
        updatedFavoriteIds.remove(event.placeId);
      } else {
        updatedFavoriteIds.add(event.placeId);
      }

      emit(currentState.copyWith(favoriteIds: updatedFavoriteIds));

      // Update in Firestore
      await _firestoreService.toggleFavorite(user.uid, event.placeId);

      // Get latest favorites to ensure consistency
      final latestFavoriteIds = await _firestoreService.getFavorites(user.uid);
      emit(currentState.copyWith(favoriteIds: latestFavoriteIds));
    } catch (e) {
      // Revert to previous state on error
      emit(currentState);
      emit(PlacesError(e.toString()));
    }
  }
}