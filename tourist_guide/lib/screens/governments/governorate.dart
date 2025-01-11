import 'Landmark.dart';

/// Represents a Governorate
class Governorate {
  final String name;
  final String image;
  final List<Landmark> landmarks;

  Governorate({
    required this.name,
    required this.image,
    required this.landmarks,
  });
}
