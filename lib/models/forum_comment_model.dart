class ForumComment {
  final String id;
  final String postId;
  final String userId;
  final String nickname;
  final String avatarUrl;
  final String content;
  final DateTime timestamp;

  ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'nickname': nickname,
    'avatarUrl': avatarUrl,
    'content': content,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory ForumComment.fromJson(Map<String, dynamic> json) => ForumComment(
    id: json['id'],
    postId: json['postId'],
    userId: json['userId'],
    nickname: json['nickname'] ?? 'Аноним',
    avatarUrl: json['avatarUrl'] ?? '',
    content: json['content'],
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
  );
}