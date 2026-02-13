// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // === ТЕКУЩИЙ ПОЛЬЗОВАТЕЛЬ ===
  User? get currentUser => _auth.currentUser;

  // === ПОТОК АВТОРИЗАЦИИ ===
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // === РЕГИСТРАЦИЯ ===
  Future<User?> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'subscription': 'free',
        'settings': {},
      });

      notifyListeners(); // ← ВАЖНО: обновляем UI
      return user;
    } catch (e) {
      print('Error in registration: $e');
      rethrow;
    }
  }

  // === ВХОД ===
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      await _firestore.collection('users').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      notifyListeners(); // ← ВАЖНО
      return user;
    } catch (e) {
      print('Error in sign in: $e');
      rethrow;
    }
  }

  // === ВЫХОД ===
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners(); // ← ВАЖНО
    } catch (e) {
      print('Error in sign out: $e');
      rethrow;
    }
  }

  // === СБРОС ПАРОЛЯ ===
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error in password reset: $e');
      rethrow;
    }
  }
}