import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../models/admin_log_model.dart';
import '../models/volunteer_profile_model.dart';
import '../models/practice_model.dart';
import '../models/chat_session_model.dart';
import '../models/emotion_entry_model.dart';
import '../models/food_entry_model.dart';
import '../models/forum_post_model.dart';
import '../models/forum_comment_model.dart';
import '../models/user_stats_model.dart';
import '../models/practice_journal_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= USER =================

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson({...doc.data()!, 'uid': doc.id});
    }
    return null;
  }

  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toJson());
  }

  // ================= EMOTION ENTRIES =================

  Stream<List<EmotionEntry>> getEmotionEntries(String userId) {
    return _db
        .collection('emotion_entries')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((q) => q.docs
        .map((d) => EmotionEntry.fromJson({...d.data(), 'id': d.id}))
        .toList());
  }

  Future<void> addEmotionEntry(EmotionEntry entry) async {
    await _db.collection('emotion_entries').doc(entry.id).set(entry.toJson());
  }

  Future<void> updateEmotionEntry(EmotionEntry entry) async {
    await _db.collection('emotion_entries').doc(entry.id).update(entry.toJson());
  }

  Future<void> deleteEmotionEntry(String entryId) async {
    await _db.collection('emotion_entries').doc(entryId).delete();
  }

  // ================= FOOD ENTRIES =================

  Stream<List<FoodEntry>> getFoodEntries(String userId) {
    return _db
        .collection('food_entries')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((q) => q.docs
        .map((d) => FoodEntry.fromJson({...d.data(), 'id': d.id}))
        .toList());
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _db.collection('food_entries').doc(entry.id).set(entry.toJson());
  }

  Future<void> updateFoodEntry(FoodEntry entry) async {
    await _db.collection('food_entries').doc(entry.id).update(entry.toJson());
  }

  Future<void> deleteFoodEntry(String entryId) async {
    await _db.collection('food_entries').doc(entryId).delete();
  }

  // ================= FORUM POSTS & COMMENTS =================

  Stream<List<ForumPost>> getForumPosts({int limit = 20}) {
    return _db
        .collection('forum_posts')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((q) => q.docs.map((d) {
      final data = d.data();
      return ForumPost(
        id: d.id,
        userId: data['userId'] ?? '',
        nickname: data['nickname'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        content: data['content'] ?? '',
        commentCount: data['commentCount'] ?? 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
      );
    }).toList());
  }

  Future<String> addForumPost(ForumPost post) async {
    final ref = _db.collection('forum_posts').doc();
    await ref.set({
      'userId': post.userId,
      'nickname': post.nickname,
      'avatarUrl': post.avatarUrl,
      'content': post.content,
      'commentCount': post.commentCount,
      'timestamp': post.timestamp.millisecondsSinceEpoch,
    });
    return ref.id;
  }

  Future<void> addForumComment(ForumComment comment) async {
    // Проверяем, что postId не пустой
    if (comment.postId.isEmpty) {
      print('❌ Ошибка: postId пустой');
      throw Exception('postId не может быть пустым');
    }

    // Генерируем новый ID для комментария, если он пустой
    final commentId = comment.id.isEmpty
        ? _db.collection('forum_posts').doc(comment.postId).collection('comments').doc().id
        : comment.id;

    // Создаем новый комментарий с правильным ID
    final newComment = ForumComment(
      id: commentId,
      postId: comment.postId,
      userId: comment.userId,
      nickname: comment.nickname,
      avatarUrl: comment.avatarUrl,
      content: comment.content,
      timestamp: comment.timestamp,
    );

    await _db
        .collection('forum_posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(commentId)
        .set(newComment.toJson());

    print('✅ Комментарий добавлен с ID: $commentId для поста: ${comment.postId}');
  }

  Stream<List<ForumComment>> getForumComments(String postId) {
    return _db
        .collection('forum_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((q) => q.docs
        .map((d) => ForumComment.fromJson({...d.data(), 'id': d.id, 'postId': postId}))
        .toList());
  }

  // ================= USER STATS =================

  Stream<UserStats?> getUserStats(String userId) {
    return _db
        .collection('user_stats')
        .doc(userId)
        .snapshots()
        .map((d) {
      if (d.exists && d.data() != null) {
        return UserStats.fromJson({...d.data()!, 'userId': userId});
      }
      return null;
    });
  }

  Future<void> updateUserStats(String userId) async {
    await _db.collection('user_stats').doc(userId).set({
      'userId': userId,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  // ================= ADMIN =================

  Stream<List<UserModel>> getAllUsers({
    UserRole? roleFilter,
    bool? isApproved,
  }) {
    Query<Map<String, dynamic>> query = _db.collection('users');

    if (roleFilter != null) {
      query = query.where('role', isEqualTo: roleFilter.index);
    }
    if (isApproved != null) {
      query = query.where('isApproved', isEqualTo: isApproved);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((q) => q.docs
        .map((d) =>
        UserModel.fromJson({...d.data(), 'uid': d.id}))
        .toList());
  }

  Future<Map<String, dynamic>> getAdminStats() async {
    final usersCount = await _db.collection('users').count().get();
    final volunteersPending = await _db
        .collection('volunteers')
        .where('status', isEqualTo: VolunteerStatus.pending.index)
        .count()
        .get();
    final postsCount = await _db.collection('forum_posts').count().get();
    final practicesCount = await _db.collection('practices').count().get();
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final activeToday = await _db
        .collection('users')
        .where('lastLogin', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
        .count()
        .get();

    return {
      'totalUsers': usersCount.count,
      'pendingVolunteers': volunteersPending.count,
      'totalPosts': postsCount.count,
      'totalPractices': practicesCount.count,
      'activeToday': activeToday.count,
    };
  }

  Future<void> toggleUserBlock(String userId, bool isBlocked, String reason) async {
    await _db.collection('users').doc(userId).update({
      'isBlocked': isBlocked,
      'blockedReason': isBlocked ? reason : null,
      'blockedAt': isBlocked ? DateTime.now().millisecondsSinceEpoch : null,
      'blockedBy': isBlocked ? _auth.currentUser?.uid : null,
    });
  }

  Stream<List<AdminLog>> getAdminLogs({int limit = 50}) {
    return _db
        .collection('admin_logs')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((q) => q.docs
        .map((d) => AdminLog.fromJson({...d.data(), 'id': d.id}))
        .toList());
  }

  Future<void> logAdminAction(AdminLog log) async {
    await _db.collection('admin_logs').doc(log.id).set(log.toJson());
  }

  // ================= PRACTICES =================

  Stream<List<Practice>> getPractices() {
    return _db
        .collection('practices')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((q) => q.docs
        .map((d) => Practice.fromJson({...d.data(), 'id': d.id}))
        .toList());
  }

  Future<void> addPractice(Practice practice) async {
    await _db.collection('practices').doc(practice.id).set(practice.toJson());
  }

  Future<void> updatePractice(Practice practice) async {
    await _db.collection('practices').doc(practice.id).update(practice.toJson());
  }

  Future<void> deletePractice(String practiceId) async {
    await _db.collection('practices').doc(practiceId).delete();
  }

  // ================= PRACTICE JOURNAL =================

  Future<void> savePracticeJournalEntry(PracticeJournalEntry entry) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _db
        .collection('users')
        .doc(userId)
        .collection('practice_journal')
        .doc(entry.id)
        .set(entry.toJson());
  }

  Stream<List<PracticeJournalEntry>> getPracticeJournalEntries() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(userId)
        .collection('practice_journal')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((q) => q.docs
        .map((d) => PracticeJournalEntry.fromJson(d.data()))
        .toList());
  }

  // ================= FORUM =================

  Future<void> deleteForumPost(String postId) async {
    await _db.collection('forum_posts').doc(postId).delete();
  }

  Future<void> deleteForumComment(String postId, String commentId) async {
    await _db
        .collection('forum_posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  // ================= CHAT (AI sessions) =================

  Stream<List<ChatSession>> getUserChatSessions(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((q) => q.docs
        .map((d) => ChatSession.fromJson({...d.data(), 'id': d.id}))
        .toList());
  }

  Future<String> createChatSession(String userId, String initialMessage) async {
    final ref = _db.collection('users').doc(userId).collection('chat_sessions').doc();
    final now = DateTime.now();
    final session = ChatSession(
      id: ref.id,
      userId: userId,
      title: initialMessage,
      messages: [
        ChatMessage(role: 'user', content: initialMessage, timestamp: now),
      ],
      createdAt: now,
      updatedAt: now,
    );
    await ref.set(session.toJson());
    return ref.id;
  }

  Stream<ChatSession?> getChatSession(String userId, String sessionId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(sessionId)
        .snapshots()
        .map((d) {
      if (d.exists && d.data() != null) {
        return ChatSession.fromJson({...d.data()!, 'id': d.id});
      }
      return null;
    });
  }

  Future<void> addMessageToChat(String userId, String sessionId, ChatMessage message) async {
    final ref = _db.collection('users').doc(userId).collection('chat_sessions').doc(sessionId);
    final doc = await ref.get();
    if (!doc.exists || doc.data() == null) return;
    final data = doc.data()!;
    final messages = (data['messages'] as List?)?.map((m) => m as Map<String, dynamic>).toList() ?? [];
    messages.add(message.toJson());
    await ref.update({
      'messages': messages,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // ================= VOLUNTEERS =================

  /// Получить заявки в статусе pending
  Stream<List<VolunteerProfile>> getPendingVolunteerApplications() {
    return _db
        .collection('volunteers')
        .where('status', isEqualTo: VolunteerStatus.pending.index)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((q) {
      return q.docs
          .map((d) {
        final data = d.data();
        data['id'] = d.id;
        return VolunteerProfile.fromJson(data);
      })
          .toList();
    });
  }

  /// Создать заявку волонтёра с конкретным ID
  Future<void> createVolunteerApplicationWithId(String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection('volunteers').doc(docId).set(data);
      print('✅ Заявка создана с ID: $docId');
    } catch (e) {
      print('❌ Ошибка создания заявки: $e');
      rethrow;
    }
  }

  /// Получить профиль волонтера по ID заявки
  Future<VolunteerProfile?> getVolunteerProfile(String volunteerId) async {
    try {
      final doc = await _db.collection('volunteers').doc(volunteerId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return VolunteerProfile.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ Ошибка получения профиля: $e');
      return null;
    }
  }

  /// Обновить статус заявки волонтера
  Future<void> updateVolunteerStatus(
      String volunteerId,
      VolunteerStatus status, {
        String? reviewComment,
        String? reviewerId,
      }) async {
    try {
      await _db.collection('volunteers').doc(volunteerId).update({
        'status': status.index,
        'reviewedAt': DateTime.now().millisecondsSinceEpoch,
        if (reviewComment != null) 'reviewComment': reviewComment,
        if (reviewerId != null) 'reviewerId': reviewerId,
      });
      print('✅ Статус заявки обновлен');
    } catch (e) {
      print('❌ Ошибка обновления статуса: $e');
      rethrow;
    }
  }

  /// Получить список одобренных волонтёров (ЕДИНСТВЕННОЕ ОПРЕДЕЛЕНИЕ)
  Stream<List<VolunteerProfile>> getApprovedVolunteers() {
    return _db
        .collection('volunteers')
        .where('status', isEqualTo: VolunteerStatus.approved.index)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((q) {
      return q.docs
          .map((d) {
        final data = d.data();
        data['id'] = d.id;
        return VolunteerProfile.fromJson(data);
      })
          .toList();
    });
  }

  /// Получить заявку волонтера по userId
  Future<VolunteerProfile?> getVolunteerApplicationByUserId(String userId) async {
    try {
      final query = await _db
          .collection('volunteers')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        final data = doc.data();
        data['id'] = doc.id;
        return VolunteerProfile.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ Ошибка получения заявки по userId: $e');
      return null;
    }
  }

  // ================= VOLUNTEER CHAT (user <-> volunteer) =================

  /// Список чатов пользователя с волонтерами (по userId)
  Stream<List<VolunteerChatSession>> getUserVolunteerChats(String userId) {
    return _db
        .collection('volunteer_chats')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((q) {
      final list = q.docs
          .map((d) => VolunteerChatSession.fromJson({...d.data(), 'id': d.id}))
          .toList();
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return list;
    });
  }

  /// Список чатов волонтера (психолога) с пользователями
  Stream<List<VolunteerChatSession>> getVolunteerChats(String volunteerUserId) {
    return _db
        .collection('volunteer_chats')
        .where('volunteerUserId', isEqualTo: volunteerUserId)
        .snapshots()
        .map((q) {
      final list = q.docs
          .map((d) => VolunteerChatSession.fromJson({...d.data(), 'id': d.id}))
          .toList();
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return list;
    });
  }

  Future<String> createOrGetVolunteerChat(String userId, String volunteerUserId, String volunteerName, {String? userName}) async {
    final existing = await _db
        .collection('volunteer_chats')
        .where('userId', isEqualTo: userId)
        .where('volunteerUserId', isEqualTo: volunteerUserId)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) return existing.docs.first.id;

    final ref = _db.collection('volunteer_chats').doc();
    final now = DateTime.now();
    await ref.set({
      'id': ref.id,
      'userId': userId,
      'volunteerUserId': volunteerUserId,
      'volunteerName': volunteerName,
      'userName': userName,
      'status': 'pending',
      'messages': <Map<String, dynamic>>[],
      'createdAt': now.millisecondsSinceEpoch,
      'updatedAt': now.millisecondsSinceEpoch,
    });
    return ref.id;
  }

  Stream<VolunteerChatSession?> getVolunteerChatSession(String chatId) {
    return _db.collection('volunteer_chats').doc(chatId).snapshots().map((d) {
      if (d.exists && d.data() != null) {
        return VolunteerChatSession.fromJson({...d.data()!, 'id': d.id});
      }
      return null;
    });
  }

  Future<void> addVolunteerChatMessage(String chatId, ChatMessage message) async {
    final ref = _db.collection('volunteer_chats').doc(chatId);
    final doc = await ref.get();
    if (!doc.exists || doc.data() == null) return;
    final data = doc.data()!;
    final messages = (data['messages'] as List?)?.map((m) => m as Map<String, dynamic>).toList() ?? [];
    messages.add(message.toJson());
    await ref.update({
      'messages': messages,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> acceptVolunteerChatRequest(String chatId) async {
    await _db.collection('volunteer_chats').doc(chatId).update({
      'status': 'accepted',
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }
}

/// Модель чата пользователя с волонтером
class VolunteerChatSession {
  final String id;
  final String userId;
  final String volunteerUserId;
  final String volunteerName;
  final String? userName; // имя пользователя (для отображения у психолога)
  final String status; // pending | accepted
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  VolunteerChatSession({
    required this.id,
    required this.userId,
    required this.volunteerUserId,
    required this.volunteerName,
    this.userName,
    required this.status,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'volunteerUserId': volunteerUserId,
    'volunteerName': volunteerName,
    'userName': userName,
    'status': status,
    'messages': messages.map((m) => m.toJson()).toList(),
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
  };

  factory VolunteerChatSession.fromJson(Map<String, dynamic> json) {
    final messages = (json['messages'] as List?)
        ?.map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
        .toList() ?? [];
    return VolunteerChatSession(
      id: json['id'],
      userId: json['userId'],
      volunteerUserId: json['volunteerUserId'],
      volunteerName: json['volunteerName'] ?? 'Волонтёр',
      userName: json['userName'],
      status: json['status'] ?? 'pending',
      messages: messages,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }
}