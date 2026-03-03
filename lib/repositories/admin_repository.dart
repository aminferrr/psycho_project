import '../models/user_model.dart';
import '../models/volunteer_profile_model.dart';
import '../models/admin_log_model.dart';
import '../models/practice_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class AdminRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  AdminRepository(this._firestoreService, this._authService);

  Future<Map<String, dynamic>> getDashboardStats() async {
    return _firestoreService.getAdminStats();
  }

  Stream<List<UserModel>> getAllUsers({UserRole? role, bool? isApproved}) {
    return _firestoreService.getAllUsers(roleFilter: role, isApproved: isApproved);
  }

  Future<void> addPractice(Practice practice) async {
    await _firestoreService.addPractice(practice);
  }

  Future<void> updatePractice(Practice practice) async {
    await _firestoreService.updatePractice(practice);
  }

  Future<void> deletePractice(String practiceId, String practiceTitle) async {
    await _firestoreService.deletePractice(practiceId);
  }

  Future<void> deletePost(String postId, String authorId) async {
    await _firestoreService.deleteForumPost(postId);
  }

  Stream<List<AdminLog>> getAdminLogs() {
    return _firestoreService.getAdminLogs(limit: 50);
  }
}
