import '../../models/governorate.dart';
import '../../models/landmark.dart';

abstract class IGovernorateRepository {
  Future<List<Governorate>> getAllGovernorates();
  Future<Governorate?> getGovernorateById(String id);
  Future<List<Landmark>> getLandmarksByGovernorate(String governorateId);
  Future<Governorate?> getGovernorateWithLandmarks(String governorateId);
  Future<List<Governorate>> searchGovernorates(String query);
}
