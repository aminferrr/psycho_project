import '../models/practice_model.dart';
import '../services/firestore_service.dart';

class PracticeRepository {
  final FirestoreService _firestoreService;

  PracticeRepository(this._firestoreService);

  Stream<List<Practice>> getPractices() {
    return _firestoreService.getPractices();
  }

}