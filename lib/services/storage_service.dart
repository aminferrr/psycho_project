import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadUserImage(String userId, String filePath) async {
    try {
      Reference ref = _storage.ref().child('user_images/$userId');
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> deleteUserImage(String userId) async {
    try {
      await _storage.ref().child('user_images/$userId').delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<String> uploadPracticeImage(String practiceId, String filePath) async {
    try {
      Reference ref = _storage.ref().child('practice_images/$practiceId');
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading practice image: $e');
      rethrow;
    }
  }

  Future<String> uploadPracticeAudio(String practiceId, String filePath) async {
    try {
      Reference ref = _storage.ref().child('practice_audio/$practiceId');
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading practice audio: $e');
      rethrow;
    }
  }
}