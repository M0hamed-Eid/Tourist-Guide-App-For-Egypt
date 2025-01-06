import '../../gen/assets.gen.dart';
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
}
