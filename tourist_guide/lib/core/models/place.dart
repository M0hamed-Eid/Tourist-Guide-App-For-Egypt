class Place {
  final String id;
  final String nameKey;
  final String governorateKey;
  final String imageUrl;
  final String descriptionKey;
  final String category;

  Place({
    required this.id,
    required this.nameKey,
    required this.governorateKey,
    required this.imageUrl,
    required this.descriptionKey,
    this.category = '',
  });

  Place copyWith({
    String? id,
    String? nameKey,
    String? governorateKey,
    String? imageUrl,
    String? descriptionKey,
    String? category,
  }) {
    return Place(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      governorateKey: governorateKey ?? this.governorateKey,
      imageUrl: imageUrl ?? this.imageUrl,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      category: category ?? this.category,
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
    );
  }
}