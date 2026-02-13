class EmotionEntry {
  final String id;
  final String userId;
  final DateTime date;
  final int moodLevel;
  final String emoji;
  final String description;
  final String thoughts;
  final String feelings;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmotionEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.moodLevel,
    required this.emoji,
    required this.description,
    required this.thoughts,
    required this.feelings,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'moodLevel': moodLevel,
      'emoji': emoji,
      'description': description,
      'thoughts': thoughts,
      'feelings': feelings,
      'tags': tags,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory EmotionEntry.fromJson(Map<String, dynamic> json) {
    return EmotionEntry(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      moodLevel: json['moodLevel'],
      emoji: json['emoji'],
      description: json['description'],
      thoughts: json['thoughts'],
      feelings: json['feelings'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }
}