import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/place.dart';
import '../../repositories/interfaces/auth_repository.dart';
import '../../repositories/interfaces/favorites_repository.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final IFavoritesRepository _favoritesRepository;
  final IAuthRepository _authRepository;

  FavoritesBloc({
    required IAuthRepository authRepository,
    required IFavoritesRepository favoritesRepository,
  })  : _favoritesRepository = favoritesRepository,
        _authRepository = authRepository,
        super(FavoritesInitial()) {
    on<LoadFavorites>(_handleLoadFavorites);
    on<ToggleFavorite>(_handleToggleFavorite);
  }

  Future<void> _handleLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        final favoriteIds = await _favoritesRepository.getFavorites(user.uid);

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
      final user = _authRepository.currentUser;
      if (user == null) {
        emit(FavoritesError('User not authenticated'));
        return;
      }

      final currentState = state;
      if (currentState is FavoritesLoaded) {

        final isCurrentlyFavorite =
            currentState.places.any((p) => p.id == event.placeId);
        final updatedPlaces = isCurrentlyFavorite
            ? currentState.places.where((p) => p.id != event.placeId).toList()
            : [
                ...currentState.places,
                AppConstants.allPlaces.firstWhere((p) => p.id == event.placeId)
              ];

        emit(FavoritesLoaded(places: updatedPlaces));

        await _favoritesRepository.toggleFavorite(user.uid, event.placeId);
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
