// lib/core/repositories/governorate_repository.dart
import '../models/governorate.dart';
import '../models/landmark.dart';
import '../../gen/assets.gen.dart';

class GovernorateRepository {
  static List<Governorate> getGovernorates() {
    return [
      Governorate(
        name: 'Cairo',
        description: 'The capital of Egypt and largest city in the Arab world',
        image: Assets.images.cairo,  // Use AssetGenImage directly
        landmarks: [
          Landmark(
            id: '1',
            name: 'Egyptian Museum',
            description: 'Home to an extensive collection of ancient Egyptian antiquities, including treasures from Tutankhamun\'s tomb.',
            image: Assets.images.museum,  // Use AssetGenImage directly
            location: 'Tahrir Square',
            governorate: 'Cairo',
            rating: 4.8,
            latitude: 30.0478,
            longitude: 31.2336,
          ),
          Landmark(
            id: '2',
            name: 'Khan el-Khalili',
            description: 'A famous bazaar and souq in Cairo\'s historic center, dating back to the 14th century.',
            image: Assets.images.khanKhalili,  // Use AssetGenImage directly
            location: 'El-Gamaleya',
            governorate: 'Cairo',
            rating: 4.6,
            latitude: 30.0477,
            longitude: 31.2622,
          ),
        ],
      ),
      Governorate(
        name: 'Luxor',
        description: 'Ancient Egypt\'s capital Thebes, known as the world\'s greatest open-air museum',
        image: Assets.images.luxor,  // Use AssetGenImage directly
        landmarks: [
          Landmark(
            id: '3',
            name: 'Karnak Temple',
            description: 'A vast temple complex dedicated to the Theban triad, built over 2,000 years.',
            image: Assets.images.karnak,  // Use AssetGenImage directly
            location: 'Karnak',
            governorate: 'Luxor',
            rating: 4.9,
            latitude: 25.7188,
            longitude: 32.6577,
          ),
          Landmark(
            id: '4',
            name: 'Valley of the Kings',
            description: 'Ancient burial ground of Egyptian pharaohs including Tutankhamun.',
            image: Assets.images.valleyKings,  // Use AssetGenImage directly
            location: 'West Bank',
            governorate: 'Luxor',
            rating: 4.8,
            latitude: 25.7402,
            longitude: 32.6014,
          ),
        ],
      ),
      // Add more governorates as needed
    ];
  }
}