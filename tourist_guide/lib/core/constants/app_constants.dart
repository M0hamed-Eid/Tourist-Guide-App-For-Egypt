import '../../gen/assets.gen.dart';
import '../models/landmark.dart';
import '../models/place.dart';

class AppConstants {
  static List<Place> suggestedPlaces = [
    Place(
      id: '1',
      nameKey: 'places.pyramids.name',
      governorateKey: 'governorates.giza',
      imageUrl: Assets.images.pyramids.path,
      descriptionKey: 'places.pyramids.description',
    ),
    Place(
      id: '2',
      nameKey: 'places.karnak.name',
      governorateKey: 'governorates.luxor',
      imageUrl: Assets.images.karnak.path,
      descriptionKey: 'places.karnak.description',
    ),
    Place(
      id: '3',
      nameKey: 'places.library.name',
      governorateKey: 'governorates.alexandria',
      imageUrl: Assets.images.library.path,
      descriptionKey: 'places.library.description',
    ),
    Place(
      id: '4',
      nameKey: 'places.valley_kings.name',
      governorateKey: 'governorates.luxor',
      imageUrl: Assets.images.valleyKings.path,
      descriptionKey: 'places.valley_kings.description',
    ),
  ];

  static List<Place> popularPlaces = [
    Place(
      id: '5',
      nameKey: 'places.museum.name',
      governorateKey: 'governorates.cairo',
      imageUrl: Assets.images.museum.path,
      descriptionKey: 'places.museum.description',
    ),
    Place(
      id: '6',
      nameKey: 'places.abu_simbel.name',
      governorateKey: 'governorates.aswan',
      imageUrl: Assets.images.abuSimbel.path,
      descriptionKey: 'places.abu_simbel.description',
    ),
    Place(
      id: '7',
      nameKey: 'places.siwa.name',
      governorateKey: 'governorates.matrouh',
      imageUrl: Assets.images.siwa.path,
      descriptionKey: 'places.siwa.description',
    ),
    Place(
      id: '8',
      nameKey: 'places.citadel.name',
      governorateKey: 'governorates.alexandria',
      imageUrl: Assets.images.citadel.path,
      descriptionKey: 'places.citadel.description',
    ),
  ];

  static List<Place> get allPlaces => [...suggestedPlaces, ...popularPlaces];

  static final List<Landmark> landmarks = [
    Landmark(
      id: '1',
      name: 'Pyramids of Giza',
      governorate: 'Giza',
      description: 'Ancient Egyptian pyramids complex',
      image: Assets.images.pyramids,
      location: 'Al Haram, Giza Governorate',  // Added location
      rating: 4.9,  // Added rating
      latitude: 29.9792,
      longitude: 31.1342,
    ),
    Landmark(
      id: '2',
      name: 'Karnak Temple',
      governorate: 'Luxor',
      description: 'A vast temple complex dedicated to the Theban triad',
      image: Assets.images.karnak,
      location: 'Karnak, Luxor',  // Added location
      rating: 4.8,  // Added rating
      latitude: 25.7188,
      longitude: 32.6577,
    ),
    Landmark(
      id: '3',
      name: 'Egyptian Museum',
      governorate: 'Cairo',
      description: 'Home to an extensive collection of ancient Egyptian antiquities',
      image: Assets.images.museum,
      location: 'Tahrir Square, Cairo',  // Added location
      rating: 4.7,  // Added rating
      latitude: 30.0478,
      longitude: 31.2336,
    ),
    Landmark(
      id: '4',
      name: 'Abu Simbel Temples',
      governorate: 'Aswan',
      description: 'Ancient temples of Ramesses II',
      image: Assets.images.abuSimbel,
      location: 'Abu Simbel, Aswan',  // Added location
      rating: 4.9,  // Added rating
      latitude: 22.3372,
      longitude: 31.6258,
    ),
    Landmark(
      id: '5',
      name: 'Valley of the Kings',
      governorate: 'Luxor',
      description: 'Ancient burial ground of Egyptian pharaohs',
      image: Assets.images.valleyKings,
      location: 'West Bank, Luxor',  // Added location
      rating: 4.8,  // Added rating
      latitude: 25.7402,
      longitude: 32.6014,
    ),
    Landmark(
      id: '6',
      name: 'Bibliotheca Alexandrina',
      governorate: 'Alexandria',
      description: 'Modern library and cultural center',
      image: Assets.images.library,
      location: 'Corniche, Alexandria',  // Added location
      rating: 4.6,  // Added rating
      latitude: 31.2089,
      longitude: 29.9092,
    ),
  ];

  // Add constants for ratings range
  static const double minRating = 1.0;
  static const double maxRating = 5.0;

  // Add constants for map zoom levels
  static const double defaultMapZoom = 15.0;
  static const double maxMapZoom = 18.0;
  static const double minMapZoom = 10.0;

  // Add constants for location precision
  static const int locationPrecision = 4;

  // Add constants for image dimensions
  static const double cardImageHeight = 120.0;
  static const double cardImageWidth = 120.0;
  static const double detailImageHeight = 250.0;

  // Add constants for UI spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardBorderRadius = 12.0;
}
