import '../models/emotion_entry_model.dart';
import '../services/firestore_service.dart';

class EmotionRepository {
  final FirestoreService _firestoreService;

  EmotionRepository(this._firestoreService);

  Stream<List<EmotionEntry>> getEmotionEntries(String userId) {
    return _firestoreService.getEmotionEntries(userId);
  }

  Future<void> addEmotionEntry(EmotionEntry entry) async {
    await _firestoreService.addEmotionEntry(entry);
  }

  Future<void> updateEmotionEntry(EmotionEntry entry) async {
    await _firestoreService.updateEmotionEntry(entry);
  }

  Future<void> deleteEmotionEntry(String entryId) async {
    await _firestoreService.deleteEmotionEntry(entryId);
  }
}