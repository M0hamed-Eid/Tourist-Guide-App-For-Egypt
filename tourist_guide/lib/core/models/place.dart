import 'package:easy_localization/easy_localization.dart';

class Place {
  final String id;
  final String nameKey;
  final String governorateKey;
  final String imageUrl;
  final String descriptionKey;
  final bool isFavorite;

  Place({
    required this.id,
    required this.nameKey,
    required this.governorateKey,
    required this.imageUrl,
    required this.descriptionKey,
    this.isFavorite = false,
  });

  Place copyWith({
    String? id,
    String? nameKey,
    String? governorateKey,
    String? imageUrl,
    String? descriptionKey,
    bool? isFavorite,
  }) {
    return Place(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      governorateKey: governorateKey ?? this.governorateKey,
      imageUrl: imageUrl ?? this.imageUrl,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}