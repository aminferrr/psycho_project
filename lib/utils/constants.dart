class AppConstants {
  static const String appName = 'MindCare';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String emotionEntriesCollection = 'emotion_entries';
  static const String foodEntriesCollection = 'food_entries';
  static const String practicesCollection = 'practices';
  static const String forumPostsCollection = 'forum_posts';

  // Mood levels
  static const List<String> moodLevels = [
    '😢 Очень плохо',
    '😔 Плохо',
    '😐 Нормально',
    '😊 Хорошо',
    '😄 Отлично'
  ];

  // Practice categories
  static const List<String> practiceCategories = [
    'breathing',
    'grounding',
    'visualization',
    'mindfulness'
  ];
}