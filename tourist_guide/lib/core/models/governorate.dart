import 'landmark.dart';
import '../../gen/assets.gen.dart';

class Governorate {
  final String name;
  final String description;
  final AssetGenImage image;  // Change to AssetGenImage
  final List<Landmark> landmarks;

  const Governorate({
    required this.name,
    required this.description,
    required this.image,
    required this.landmarks,
  });
}