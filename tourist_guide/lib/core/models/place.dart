
class Place {
  final String id;
  final String nameKey;
  final String governorateKey;
  final String imageUrl;
  final String descriptionKey;
  final String category;
  final bool isFavorite;

  Place({
    required this.id,
    required this.nameKey,
    required this.governorateKey,
    required this.imageUrl,
    required this.descriptionKey,
    this.category = '',
    this.isFavorite = false,
  });

  Place copyWith({
    String? id,
    String? nameKey,
    String? governorateKey,
    String? imageUrl,
    String? descriptionKey,
    String? category,
    bool? isFavorite,
  }) {
    return Place(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      governorateKey: governorateKey ?? this.governorateKey,
      imageUrl: imageUrl ?? this.imageUrl,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'governorateKey': governorateKey,
      'imageUrl': imageUrl,
      'descriptionKey': descriptionKey,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      governorateKey: json['governorateKey'] as String,
      imageUrl: json['imageUrl'] as String,
      descriptionKey: json['descriptionKey'] as String,
      category: json['category'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}