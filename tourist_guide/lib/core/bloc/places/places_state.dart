part of 'places_bloc.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {
  final bool isSuggestedLoading;
  final bool isPopularLoading;

  PlacesLoading({
    this.isSuggestedLoading = false,
    this.isPopularLoading = false,
  });
}

class PlacesLoaded extends PlacesState {
  final List<Place> suggestedPlaces;
  final List<Place> popularPlaces;
  final List<String> favoriteIds;

  PlacesLoaded({
    required this.suggestedPlaces,
    required this.popularPlaces,
    this.favoriteIds = const [],
  });

  bool isPlaceFavorite(String placeId) => favoriteIds.contains(placeId);

  PlacesLoaded copyWith({
    List<Place>? suggestedPlaces,
    List<Place>? popularPlaces,
    List<String>? favoriteIds,
  }) {
    return PlacesLoaded(
      suggestedPlaces: suggestedPlaces ?? this.suggestedPlaces,
      popularPlaces: popularPlaces ?? this.popularPlaces,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class PlacesError extends PlacesState {
  final String message;
  final bool isSuggestedError;
  final bool isPopularError;

  PlacesError(
      this.message, {
        this.isSuggestedError = false,
        this.isPopularError = false,
      });
}