class PracticeJournalEntry {
  final String id;
  final String userId;
  final int practiceId;
  final String practiceTitle;
  final String? journalText;
  final Map<int, int>? testAnswers;
  final int? testScore;
  final DateTime createdAt;

  PracticeJournalEntry({
    required this.id,
    required this.userId,
    required this.practiceId,
    required this.practiceTitle,
    this.journalText,
    this.testAnswers,
    this.testScore,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'practiceId': practiceId,
    'practiceTitle': practiceTitle,
    'journalText': journalText,
    'testAnswers': testAnswers,
    'testScore': testScore,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory PracticeJournalEntry.fromJson(Map<String, dynamic> json) => PracticeJournalEntry(
    id: json['id'],
    userId: json['userId'],
    practiceId: json['practiceId'],
    practiceTitle: json['practiceTitle'],
    journalText: json['journalText'],
    testAnswers: json['testAnswers'] != null
        ? Map<int, int>.from(json['testAnswers'])
        : null,
    testScore: json['testScore'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
  );
}