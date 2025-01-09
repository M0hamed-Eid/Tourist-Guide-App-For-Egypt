import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoritePlaces = []; // Changed from Set to List

  bool isFavorite(String placeId) => _favoritePlaces.contains(placeId);
  
  List<String> get favoritePlaceIds => _favoritePlaces;

  void toggleFavorite(String placeId) {
    if (_favoritePlaces.contains(placeId)) {
      _favoritePlaces.remove(placeId);
    } else {
      _favoritePlaces.add(placeId); // Will be added at the end of the list
    }
    notifyListeners();
  }
}