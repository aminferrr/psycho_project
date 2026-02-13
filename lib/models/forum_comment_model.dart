class ForumComment {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime timestamp;

  ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  ForumComment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    DateTime? timestamp,
  }) {
    return ForumComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'content': content,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    return ForumComment(
      id: json['id'] ?? '',
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
    );
  }
}
