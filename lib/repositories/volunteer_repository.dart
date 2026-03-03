import 'package:uuid/uuid.dart';

import '../models/volunteer_profile_model.dart';
import '../models/user_model.dart';
import '../models/admin_log_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class VolunteerRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final AuthService _authService;

  VolunteerRepository(this._firestoreService, this._storageService, this._authService);

  Stream<List<VolunteerProfile>> getPendingApplications() {
    return _firestoreService.getPendingVolunteerApplications();
  }

  /// Отправить заявку волонтёра (при регистрации)
  Future<void> submitApplication(VolunteerProfile profile) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) throw StateError('User not logged in');

    final data = profile.toJson();
    data['userId'] = uid;
    data['status'] = VolunteerStatus.pending.index;
    data['appliedAt'] = profile.appliedAt.millisecondsSinceEpoch;
    await _firestoreService.createVolunteerApplication(data);
  }

  Future<void> approveApplication(String volunteerDocId) async {
    final profile = await _firestoreService.getVolunteerProfile(volunteerDocId);
    if (profile == null) return;

    await _firestoreService.updateVolunteerStatus(
      volunteerDocId,
      VolunteerStatus.approved,
      reviewerId: _authService.currentUser?.uid,
    );

    final user = await _firestoreService.getUser(profile.userId);
    if (user != null) {
      final updated = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName ?? profile.fullName,
        photoURL: user.photoURL,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
        subscription: user.subscription,
        settings: user.settings,
        role: UserRole.psychologist,
        isApproved: true,
        volunteerApplicationDate: user.volunteerApplicationDate,
        volunteerId: volunteerDocId,
        adminPermissions: user.adminPermissions,
      );
      await _firestoreService.updateUser(updated);
    }

    final adminUid = _authService.currentUser?.uid ?? '';
    final adminEmail = _authService.currentUser?.email ?? '';
    await _firestoreService.logAdminAction(AdminLog(
      id: const Uuid().v4(),
      adminId: adminUid,
      adminEmail: adminEmail,
      actionType: AdminActionType.approveVolunteer,
      description: 'Одобрена заявка волонтёра: ${profile.fullName}',
      targetUserId: profile.userId,
      targetId: volunteerDocId,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> rejectApplication(String volunteerDocId) async {
    final profile = await _firestoreService.getVolunteerProfile(volunteerDocId);
    await _firestoreService.updateVolunteerStatus(
      volunteerDocId,
      VolunteerStatus.rejected,
      reviewComment: 'Отклонено администратором',
      reviewerId: _authService.currentUser?.uid,
    );

    final adminUid = _authService.currentUser?.uid ?? '';
    final adminEmail = _authService.currentUser?.email ?? '';
    await _firestoreService.logAdminAction(AdminLog(
      id: const Uuid().v4(),
      adminId: adminUid,
      adminEmail: adminEmail,
      actionType: AdminActionType.rejectVolunteer,
      description: 'Отклонена заявка волонтёра${profile != null ? ': ${profile.fullName}' : ''}',
      targetId: volunteerDocId,
      timestamp: DateTime.now(),
    ));
  }

  Stream<List<VolunteerProfile>> getApprovedVolunteers() {
    return _firestoreService.getApprovedVolunteers();
  }
}
