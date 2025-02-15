import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/place.dart';
import '../../repositories/interfaces/auth_repository.dart';
import '../../repositories/interfaces/places_repository.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final IPlacesRepository _placesRepository;
  final IAuthRepository _authRepository;

  PlacesBloc({
    required IAuthRepository authRepository,
    required IPlacesRepository placesRepository,
  })  : _authRepository = authRepository,
        _placesRepository = placesRepository,
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
      if (_authRepository.currentUser != null) {
        results = await Future.wait<dynamic>([
          _placesRepository.getPlacesByCategory('suggested'),
          _placesRepository.getPlacesByCategory('popular'),
          _placesRepository.getFavorites(_authRepository.currentUser!.uid),
        ]);
      } else {
        results = await Future.wait<List<Place>>([
          _placesRepository.getPlacesByCategory('suggested'),
          _placesRepository.getPlacesByCategory('popular'),
        ]);
      }

      final List<Place> suggestedPlaces = results[0] as List<Place>;
      final List<Place> popularPlaces = results[1] as List<Place>;
      final List<String> favoriteIds = _authRepository.currentUser != null
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
      final suggestedPlaces =
          await _placesRepository.getPlacesByCategory('suggested');
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
      final popularPlaces =
          await _placesRepository.getPlacesByCategory('popular');
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
      final user = _authRepository.currentUser;
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
      await _placesRepository.toggleFavorite(user.uid, event.placeId);

      // Get latest favorites to ensure consistency
      final latestFavoriteIds = await _placesRepository.getFavorites(user.uid);
      emit(currentState.copyWith(favoriteIds: latestFavoriteIds));
    } catch (e) {
      // Revert to previous state on error
      emit(currentState);
      emit(PlacesError(e.toString()));
    }
  }
}
