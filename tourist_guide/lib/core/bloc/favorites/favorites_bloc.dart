import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/place.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadFavorites>(_handleLoadFavorites);
    on<ToggleFavorite>(_handleToggleFavorite);
  }

  Future<void> _handleLoadFavorites(
      LoadFavorites event,
      Emitter<FavoritesState> emit,
      ) async {
    emit(FavoritesLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_places') ?? [];
      final favoritePlaces = AppConstants.allPlaces
          .where((place) => favoriteIds.contains(place.id))
          .toList();
      emit(FavoritesLoaded(places: favoritePlaces));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _handleToggleFavorite(
      ToggleFavorite event,
      Emitter<FavoritesState> emit,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_places') ?? [];

      if (favoriteIds.contains(event.placeId)) {
        favoriteIds.remove(event.placeId);
      } else {
        favoriteIds.add(event.placeId);
      }

      await prefs.setStringList('favorite_places', favoriteIds);

      final favoritePlaces = AppConstants.allPlaces
          .where((place) => favoriteIds.contains(place.id))
          .toList();

      emit(FavoritesLoaded(places: favoritePlaces));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}