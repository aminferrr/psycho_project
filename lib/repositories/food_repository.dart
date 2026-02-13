import '../models/food_entry_model.dart';
import '../services/firestore_service.dart';

class FoodRepository {
  final FirestoreService _firestoreService;

  FoodRepository(this._firestoreService);

  Stream<List<FoodEntry>> getFoodEntries(String userId) {
    return _firestoreService.getFoodEntries(userId);
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _firestoreService.addFoodEntry(entry);
  }

  Future<void> updateFoodEntry(FoodEntry entry) async {
    await _firestoreService.updateFoodEntry(entry);
  }

  Future<void> deleteFoodEntry(String entryId) async {
    await _firestoreService.deleteFoodEntry(entryId);
  }
}