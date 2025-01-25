part of 'places_bloc.dart';

abstract class PlacesEvent {}

class LoadAllPlaces extends PlacesEvent {}

class LoadSuggestedPlaces extends PlacesEvent {}

class LoadPopularPlaces extends PlacesEvent {}

class LoadFavoritePlaces extends PlacesEvent {}

class TogglePlaceFavorite extends PlacesEvent {
  final String placeId;
  TogglePlaceFavorite(this.placeId);
}