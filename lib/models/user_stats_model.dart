class UserStats {
  final String userId;
  final List<int> weeklyMood;
  final Map<String, int> emotionTags;
  final int practiceCompletions;
  final int streak;
  final int updatedAt;

  UserStats({
    required this.userId,
    required this.weeklyMood,
    required this.emotionTags,
    required this.practiceCompletions,
    required this.streak,
    required this.updatedAt,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'] ?? '',
      weeklyMood: List<int>.from(json['weeklyMood'] ?? []),
      emotionTags: Map<String, int>.from(json['emotionTags'] ?? {}),
      practiceCompletions: json['practiceCompletions'] ?? 0,
      streak: json['streak'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'weeklyMood': weeklyMood,
      'emotionTags': emotionTags,
      'practiceCompletions': practiceCompletions,
      'streak': streak,
      'updatedAt': updatedAt,
    };
  }
}
