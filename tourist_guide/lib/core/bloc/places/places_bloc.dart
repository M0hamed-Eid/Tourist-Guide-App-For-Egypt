import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../models/place.dart';

part 'places_event.dart';

part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesBloc() : super(PlacesInitial()) {
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
      await Future.delayed(const Duration(seconds: 1));
      final suggestedPlaces = AppConstants.suggestedPlaces;
      final popularPlaces = AppConstants.popularPlaces;

      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorite_places') ?? [];
      final favoritePlaces = AppConstants.allPlaces
          .where((place) => favorites.contains(place.id))
          .toList();

      emit(PlacesLoaded(
          suggestedPlaces: suggestedPlaces,
          popularPlaces: popularPlaces,
          favoritePlaces: favoritePlaces));
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
    final currentState = state;
    emit(PlacesLoading(isSuggestedLoading: true));

    try {
      await Future.delayed(const Duration(seconds: 1));
      final suggestedPlaces = AppConstants.suggestedPlaces;

      if (currentState is PlacesLoaded) {
        emit(currentState.copyWith(suggestedPlaces: suggestedPlaces));
      } else {
        emit(PlacesLoaded(suggestedPlaces: suggestedPlaces));
      }
    } catch (e) {
      emit(PlacesError(e.toString(), isSuggestedError: true));
    }
  }

  Future<void> _handleLoadPopularPlaces(
    LoadPopularPlaces event,
    Emitter<PlacesState> emit,
  ) async {
    final currentState = state;
    emit(PlacesLoading(isPopularLoading: true));

    try {
      await Future.delayed(const Duration(seconds: 1));
      final popularPlaces = AppConstants.popularPlaces;

      if (currentState is PlacesLoaded) {
        emit(currentState.copyWith(popularPlaces: popularPlaces));
      } else {
        emit(PlacesLoaded(popularPlaces: popularPlaces));
      }
    } catch (e) {
      emit(PlacesError(e.toString(), isPopularError: true));
    }
  }

  Future<void> _handleToggleFavorite(
    TogglePlaceFavorite event,
    Emitter<PlacesState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorite_places') ?? [];

      if (favorites.contains(event.placeId)) {
        favorites.remove(event.placeId);
      } else {
        favorites.add(event.placeId);
      }

      await prefs.setStringList('favorite_places', favorites);

      if (state is PlacesLoaded) {
        final currentState = state as PlacesLoaded;

        final updatedSuggestedPlaces =
            currentState.suggestedPlaces?.map((place) {
          if (place.id == event.placeId) {
            return place.copyWith(isFavorite: favorites.contains(place.id));
          }
          return place;
        }).toList();

        final updatedPopularPlaces = currentState.popularPlaces?.map((place) {
          if (place.id == event.placeId) {
            return place.copyWith(isFavorite: favorites.contains(place.id));
          }
          return place;
        }).toList();

        final updatedFavoritePlaces = AppConstants.allPlaces
            .where((place) => favorites.contains(place.id))
            .map((place) => place.copyWith(isFavorite: true))
            .toList();

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
