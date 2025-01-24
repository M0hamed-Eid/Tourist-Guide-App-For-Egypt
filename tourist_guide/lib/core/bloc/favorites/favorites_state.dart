part of 'favorites_bloc.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Place> places;
  FavoritesLoaded({required this.places});
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}