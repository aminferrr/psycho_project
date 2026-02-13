import '../models/user_stats_model.dart';
import '../services/firestore_service.dart';

class UserStatsRepository {
  final FirestoreService _firestoreService;

  UserStatsRepository(this._firestoreService);

  Stream<UserStats?> getUserStats(String userId) {
    return _firestoreService.getUserStats(userId);
  }

  Future<void> updateUserStats(String userId) async {
    await _firestoreService.updateUserStats(userId);
  }
}
