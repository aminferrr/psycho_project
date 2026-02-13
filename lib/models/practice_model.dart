class Practice {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration;
  final String difficulty;
  final List<String> steps;
  final String? audioUrl;
  final String? imageUrl;
  final bool isPremium;
  final int likes;
  final DateTime createdAt;

  Practice({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.steps,
    this.audioUrl,
    this.imageUrl,
    this.isPremium = false,
    this.likes = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'difficulty': difficulty,
      'steps': steps,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'isPremium': isPremium,
      'likes': likes,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Practice.fromJson(Map<String, dynamic> json) {
    return Practice(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      steps: List<String>.from(json['steps']),
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      isPremium: json['isPremium'] ?? false,
      likes: json['likes'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }
}