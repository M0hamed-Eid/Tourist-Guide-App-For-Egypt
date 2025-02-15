import '../../models/governorate.dart';
import '../../models/landmark.dart';
import '../../services/firestore_service.dart';
import '../interfaces/governorate_repository.dart';

class GovernorateRepositoryImpl implements IGovernorateRepository {
  final FirestoreService _firestoreService;

  GovernorateRepositoryImpl(this._firestoreService);

  @override
  Future<List<Governorate>> getAllGovernorates() async {
    try {
      final governorates = await _firestoreService.getAllGovernorates();
      return _sortGovernoratesByName(governorates);
    } catch (e) {
      throw Exception('Failed to get all governorates: $e');
    }
  }

  @override
  Future<Governorate?> getGovernorateById(String id) async {
    try {
      return await _firestoreService.getGovernorateById(id);
    } catch (e) {
      throw Exception('Failed to get governorate by ID: $e');
    }
  }

  @override
  Future<List<Landmark>> getLandmarksByGovernorate(String governorateId) async {
    try {
      return await _firestoreService.getLandmarksByGovernorate(governorateId);
    } catch (e) {
      throw Exception('Failed to get landmarks for governorate: $e');
    }
  }

  @override
  Future<Governorate?> getGovernorateWithLandmarks(String governorateId) async {
    try {
      final governorate = await getGovernorateById(governorateId);
      if (governorate == null) return null;

      final landmarks = await getLandmarksByGovernorate(governorateId);

      return governorate.copyWith(landmarks: landmarks);
    } catch (e) {
      throw Exception('Failed to get governorate with landmarks: $e');
    }
  }

  @override
  Future<List<Governorate>> searchGovernorates(String query) async {
    try {
      final governorates = await _firestoreService.searchGovernorates(query);
      return _sortGovernoratesByName(governorates);
    } catch (e) {
      throw Exception('Failed to search governorates: $e');
    }
  }

  // Helper method to sort governorates by name
  List<Governorate> _sortGovernoratesByName(List<Governorate> governorates) {
    return governorates
      ..sort((a, b) => a.nameKey.compareTo(b.nameKey));
  }
}
