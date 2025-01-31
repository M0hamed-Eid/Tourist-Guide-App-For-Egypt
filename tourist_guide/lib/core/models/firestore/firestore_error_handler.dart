
import 'firestore_indexes.dart';
import 'firestore_place.dart';

class FirestoreErrorHandler {
  static String handleError(dynamic error) {
    if (error.toString().contains('missing index')) {
      return 'This query requires an index. Please wait while we create it.';
    }
    return 'An error occurred: ${error.toString()}';
  }

  static bool isMissingIndexError(dynamic error) {
    return error.toString().contains('missing index');
  }
}

// Usage in service
Future<List<FirestorePlace>> getTopPlacesByGovernorate(
    String governorateKey) async {
  try {
    final querySnapshot = await FirestoreIndexes
        .getPlacesByGovernorateAndRating(governorateKey)
        .get();

    return querySnapshot.docs
        .map((doc) => FirestorePlace.fromMap(doc.data()))
        .toList();
  } catch (e) {
    if (FirestoreErrorHandler.isMissingIndexError(e)) {
      // Handle missing index
      print('Creating index...');
      // You could implement a retry mechanism here
    }
    throw Exception(FirestoreErrorHandler.handleError(e));
  }
}