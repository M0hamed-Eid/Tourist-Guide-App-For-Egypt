import 'package:cloud_firestore/cloud_firestore.dart';
import '../../gen/assets.gen.dart';

class Landmark {
  final String id;
  final String name;
  final String description;
  final String imageAsset;
  final String location;
  final String governorateId;  // Changed from governorate to governorateId
  final double rating;
  final double latitude;
  final double longitude;

  const Landmark({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.location,
    required this.governorateId,  // Updated parameter
    required this.rating,
    required this.latitude,
    required this.longitude,
  });

  // Get image asset
  AssetGenImage get image => Assets.images.getByPath(imageAsset);

  factory Landmark.fromJson(Map<String, dynamic> json) {
    final GeoPoint? coordinates = json['coordinates'] as GeoPoint?;
    return Landmark(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageAsset: json['imageAsset'] ?? '',
      location: json['location'] ?? '',
      governorateId: json['governorateId'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      latitude: coordinates?.latitude ?? 0.0,
      longitude: coordinates?.longitude ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'imageAsset': imageAsset,
    'location': location,
    'governorateId': governorateId,
    'rating': rating,
    'coordinates': GeoPoint(latitude, longitude),
  };
}