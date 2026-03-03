import '../models/practice_model.dart';
import '../services/firestore_service.dart';

class PracticeRepository {
  final FirestoreService _firestoreService;

  PracticeRepository(this._firestoreService);

  Stream<List<Practice>> getPractices({String? category}) {
    if (category != null && category != 'Все') {
      return _firestoreService.getPractices().map(
        (practices) => practices.where((p) => p.category == category).toList(),
      );
    }
    return _firestoreService.getPractices();
  }

  Future<void> saveTestResult(String userId, String testId, Map<String, dynamic> result) async {
    // TODO: сохранять в Firestore при необходимости
  }

  Stream<Map<String, dynamic>?> getLatestTestResult(String userId, String testId) {
    return Stream.value(null);
  }
}
