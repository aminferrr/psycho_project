class FoodItem {
  final String name;
  final String quantity;
  final String notes;

  FoodItem({
    required this.name,
    required this.quantity,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      quantity: json['quantity'],
      notes: json['notes'] ?? '',
    );
  }
}

class FoodEntry {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String context;
  final List<FoodItem> foodItems;
  final int hungerBefore;
  final int hungerAfter;
  final List<String> emotionsBefore;
  final List<String> emotionsAfter;
  final String thoughts;
  final String behavior;

  // 🔹 Новые поля для расширенного дневника
  final String? compensation; // компенсаторные действия
  final String? triggers; // триггеры
  final String? support; // что помогло
  final String? selfNote; // фраза поддержки себе
  final String? insight; // осознания

  final DateTime createdAt;
  final DateTime updatedAt;

  FoodEntry({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.context,
    required this.foodItems,
    required this.hungerBefore,
    required this.hungerAfter,
    this.emotionsBefore = const [],
    this.emotionsAfter = const [],
    this.thoughts = '',
    this.behavior = 'normal',
    this.compensation,
    this.triggers,
    this.support,
    this.selfNote,
    this.insight,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'context': context,
      'foodItems': foodItems.map((item) => item.toJson()).toList(),
      'hungerBefore': hungerBefore,
      'hungerAfter': hungerAfter,
      'emotionsBefore': emotionsBefore,
      'emotionsAfter': emotionsAfter,
      'thoughts': thoughts,
      'behavior': behavior,
      'compensation': compensation,
      'triggers': triggers,
      'support': support,
      'selfNote': selfNote,
      'insight': insight,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'],
      userId: json['userId'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      context: json['context'],
      foodItems: (json['foodItems'] as List)
          .map((item) => FoodItem.fromJson(item))
          .toList(),
      hungerBefore: json['hungerBefore'],
      hungerAfter: json['hungerAfter'],
      emotionsBefore: List<String>.from(json['emotionsBefore'] ?? []),
      emotionsAfter: List<String>.from(json['emotionsAfter'] ?? []),
      thoughts: json['thoughts'] ?? '',
      behavior: json['behavior'] ?? 'normal',
      compensation: json['compensation'],
      triggers: json['triggers'],
      support: json['support'],
      selfNote: json['selfNote'],
      insight: json['insight'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }
}
