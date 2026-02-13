import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class UserRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  UserRepository(this._firestoreService, this._authService);

  Stream<UserModel?> get currentUser {
    return _authService.authStateChanges.asyncMap((user) async {
      if (user != null) {
        return await _firestoreService.getUser(user.uid);
      }
      return null;
    });
  }

  Future<void> createUser(UserModel user) async {
    await _firestoreService.createUser(user);
  }

  Future<void> updateUser(UserModel user) async {
    await _firestoreService.updateUser(user);
  }
}