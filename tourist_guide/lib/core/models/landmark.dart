import '../../gen/assets.gen.dart';

class Landmark {
  final String id;
  final String name;
  final String description;
  final AssetGenImage image;  // Change to AssetGenImage
  final String location;
  final String governorate;
  final double rating;
  final double latitude;
  final double longitude;

  const Landmark({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    required this.governorate,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });
}