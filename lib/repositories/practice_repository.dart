import '../models/practice_model.dart';
import '../models/practice_journal_model.dart';
import '../services/firestore_service.dart';

class PracticeRepository {
  final FirestoreService _firestoreService;

  PracticeRepository(this._firestoreService);

  Stream<List<Practice>> getPractices({String? category}) {
    if (category != null && category != 'Все') {
      return _firestoreService.getPractices().map(
              (practices) => practices.where((p) => p.category == category).toList()
      );
    }
    return _firestoreService.getPractices();
  }

  Future<void> saveTestResult(String userId, String testId, Map<String, dynamic> result) async {
    print('Saving test result for user $userId: $testId');
  }

  Stream<Map<String, dynamic>?> getLatestTestResult(String userId, String testId) {
    return Stream.value(null);
  }

  // ✅ Методы для журнала практик
  Future<void> saveJournalEntry(PracticeJournalEntry entry) async {
    await _firestoreService.savePracticeJournalEntry(entry);
  }

  Stream<List<PracticeJournalEntry>> getJournalEntries() {
    return _firestoreService.getPracticeJournalEntries();
  }
}