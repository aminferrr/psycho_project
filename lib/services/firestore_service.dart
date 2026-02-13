import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/emotion_entry_model.dart';
import '../models/food_entry_model.dart';
import '../models/practice_model.dart';
import '../models/forum_post_model.dart';
import '../models/forum_comment_model.dart';
import '../models/chat_session_model.dart';
import '../models/user_stats_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // === USER ===
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromJson({...doc.data()!, 'uid': uid}) : null;
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toJson());
  }

  // === EMOTION DIARY ===
  Stream<List<EmotionEntry>> getEmotionEntries(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('emotion_entries')
        .orderBy('date', descending: true)
        .snapshots()
        .map((q) => q.docs.map((d) => EmotionEntry.fromJson(d.data())).toList());
  }

  Future<void> addEmotionEntry(EmotionEntry entry) async {
    final ref = _db
        .collection('users')
        .doc(entry.userId)
        .collection('emotion_entries')
        .doc(entry.id);
    await ref.set(entry.toJson());
    await updateUserStats(entry.userId);
  }

  Future<void> updateEmotionEntry(EmotionEntry entry) async {
    await _db
        .collection('users')
        .doc(entry.userId)
        .collection('emotion_entries')
        .doc(entry.id)
        .update(entry.toJson());
  }

  Future<void> deleteEmotionEntry(String entryId) async {
    print('deleteEmotionEntry($entryId) — userId нужен для удаления');
  }

  // === FOOD DIARY ===
  Stream<List<FoodEntry>> getFoodEntries(String userId, {int? limit}) {
    var query = _db
        .collection('users')
        .doc(userId)
        .collection('food_entries')
        .orderBy('timestamp', descending: true);

    if (limit != null) query = query.limit(limit);
    return query.snapshots().map((q) => q.docs.map((d) => FoodEntry.fromJson(d.data())).toList());
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _db
        .collection('users')
        .doc(entry.userId)
        .collection('food_entries')
        .doc(entry.id)
        .set(entry.toJson());
  }

  Future<void> updateFoodEntry(FoodEntry entry) async {
    await _db
        .collection('users')
        .doc(entry.userId)
        .collection('food_entries')
        .doc(entry.id)
        .update(entry.toJson());
  }

  Future<void> deleteFoodEntry(String entryId) async {
    print('deleteFoodEntry($entryId) — userId нужен для удаления');
  }

  // === FORUM ===
  Future<String> addForumPost(ForumPost post) async {
    final postId = _uuid.v4();
    final newPost = post.copyWith(id: postId);
    await _db.collection('forum_posts').doc(postId).set(newPost.toJson());
    return postId;
  }

  Stream<List<ForumPost>> getForumPosts({int limit = 20}) {
    return _db
        .collection('forum_posts')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((q) => q.docs.map((d) => ForumPost.fromFirestore(d)).toList());
  }

  Future<void> addForumComment(ForumComment comment) async {
    final commentId = _uuid.v4();
    final newComment = comment.copyWith(id: commentId);
    await _db
        .collection('forum_posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(commentId)
        .set(newComment.toJson());
  }

  Stream<List<ForumComment>> getForumComments(String postId) {
    return _db
        .collection('forum_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp')
        .snapshots()
        .map((q) => q.docs.map((d) => ForumComment.fromJson(d.data())).toList());
  }

  // === CHAT ===
  Future<String> createChatSession(String userId, String initialMessage) async {
    final sessionId = _uuid.v4();
    final now = DateTime.now();
    final session = ChatSession(
      id: sessionId,
      userId: userId,
      title: initialMessage.length > 30 ? '${initialMessage.substring(0, 30)}...' : initialMessage,
      messages: [
        ChatMessage(role: 'user', content: initialMessage, timestamp: now),
      ],
      createdAt: now,
      updatedAt: now,
    );

    await _db
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(sessionId)
        .set(session.toJson());

    return sessionId;
  }

  Future<void> addMessageToChat(String userId, String sessionId, ChatMessage message) async {
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(sessionId);

    await docRef.set({
      'messages': FieldValue.arrayUnion([message.toJson()]),
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }



  Stream<ChatSession?> getChatSession(String userId, String sessionId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .doc(sessionId)
        .snapshots()
        .map((s) => s.exists ? ChatSession.fromJson(s.data()!) : null);
  }


  Stream<List<ChatSession>> getUserChatSessions(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('chat_sessions')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((q) => q.docs.map((d) => ChatSession.fromJson(d.data())).toList());
  }

  // === PRACTICES ===
  Stream<List<Practice>> getPractices({String? category}) {
    var query = _db.collection('practices').orderBy('createdAt', descending: true);
    if (category != null) query = query.where('category', isEqualTo: category);
    return query.snapshots().map((q) => q.docs.map((d) => Practice.fromJson(d.data())).toList());
  }

  // === STATS ===
  Future<void> updateUserStats(String userId) async {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final emotions = await _db
        .collection('users')
        .doc(userId)
        .collection('emotion_entries')
        .where('date', isGreaterThanOrEqualTo: weekAgo)
        .get();

    final weeklyMood = emotions.docs.map((e) => e['moodLevel'] as int).toList();
    final tags = <String, int>{};
    for (var doc in emotions.docs) {
      for (var tag in doc['tags'] as List) {
        tags[tag] = (tags[tag] ?? 0) + 1;
      }
    }

    await _db.collection('users').doc(userId).collection('stats').doc('current').set({
      'weeklyMood': weeklyMood,
      'emotionTags': tags,
      'streak': weeklyMood.length,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  Stream<UserStats?> getUserStats(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('stats')
        .doc('current')
        .snapshots()
        .map((s) => s.exists ? UserStats.fromJson(s.data()!) : null);
  }
}
