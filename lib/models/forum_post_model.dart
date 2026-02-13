import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String id;
  final String userId;
  final String nickname;
  final String avatarUrl;
  final String content;
  final int commentCount;
  final DateTime timestamp;

  ForumPost({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    required this.content,
    required this.commentCount,
    required this.timestamp,
  });

  ForumPost copyWith({
    String? id,
    String? userId,
    String? nickname,
    String? avatarUrl,
    String? content,
    int? commentCount,
    DateTime? timestamp,
  }) {
    return ForumPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      commentCount: commentCount ?? this.commentCount,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'nickname': nickname,
    'avatarUrl': avatarUrl,
    'content': content,
    'commentCount': commentCount,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory ForumPost.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ForumPost(
      id: doc.id,
      userId: data['userId'] ?? '',
      nickname: data['nickname'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      content: data['content'] ?? '',
      commentCount: data['commentCount'] ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
    );
  }
}
