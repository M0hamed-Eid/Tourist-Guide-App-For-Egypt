import 'package:easy_localization/easy_localization.dart';

class Place {
  final String id;
  final String nameKey;
  final String governorateKey;
  final String imageUrl;
  final String descriptionKey;

  Place({
    required this.id,
    required this.nameKey,
    required this.governorateKey,
    required this.imageUrl,
    required this.descriptionKey,
  });

  String get name => nameKey.tr();
  String get governorate => governorateKey.tr();
  String get description => descriptionKey.tr();
}
