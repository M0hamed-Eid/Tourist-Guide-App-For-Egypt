import 'package:easy_localization/easy_localization.dart';
import '../../gen/assets.gen.dart';
import 'landmark.dart';


class Governorate {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final String imageAsset;
  final List<Landmark> landmarks;

  const Governorate({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.imageAsset,
    this.landmarks = const [],
  });

  // Get translated name
  String get name => nameKey.tr();

  // Get translated description
  String get description => descriptionKey.tr();

  // Get image asset
  AssetGenImage get image => Assets.images.getByPath(imageAsset);

  factory Governorate.fromJson(Map<String, dynamic> json, [List<Landmark> landmarks = const []]) {
    return Governorate(
      id: json['id'] ?? '',
      nameKey: json['nameKey'] ?? '',
      descriptionKey: json['descriptionKey'] ?? '',
      imageAsset: json['imageAsset'] ?? '',
      landmarks: landmarks,
    );
  }

  Map<String, dynamic> toJson() => {
    'nameKey': nameKey,
    'descriptionKey': descriptionKey,
    'imageAsset': imageAsset,
  };

  Governorate copyWith({
    String? id,
    String? nameKey,
    String? descriptionKey,
    String? imageAsset,
    List<Landmark>? landmarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Governorate(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      imageAsset: imageAsset ?? this.imageAsset,
      landmarks: landmarks ?? this.landmarks,
    );
  }
}
