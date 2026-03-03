enum VolunteerStatus {
  pending,
  approved,
  rejected
}

class VolunteerProfile {
  final String id;
  final String userId; // uid пользователя Firebase Auth
  final String fullName;
  final int age;
  final String education;
  final String specialization;
  final String experience;
  final String motivation;
  final List<String> certificates;
  final bool hasPsychologyEducation;
  final String? organization;
  final DateTime appliedAt;
  final VolunteerStatus status;
  final String? reviewComment;
  final DateTime? reviewedAt;
  final String? reviewerId;

  VolunteerProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.age,
    required this.education,
    required this.specialization,
    required this.experience,
    required this.motivation,
    required this.certificates,
    required this.hasPsychologyEducation,
    this.organization,
    required this.appliedAt,
    required this.status,
    this.reviewComment,
    this.reviewedAt,
    this.reviewerId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'fullName': fullName,
    'age': age,
    'education': education,
    'specialization': specialization,
    'experience': experience,
    'motivation': motivation,
    'certificates': certificates,
    'hasPsychologyEducation': hasPsychologyEducation,
    'organization': organization,
    'appliedAt': appliedAt.millisecondsSinceEpoch,
    'status': status.index,
    'reviewComment': reviewComment,
    'reviewedAt': reviewedAt?.millisecondsSinceEpoch,
    'reviewerId': reviewerId,
  };

  factory VolunteerProfile.fromJson(Map<String, dynamic> json) => VolunteerProfile(
    id: json['id'],
    userId: json['userId'] ?? '',
    fullName: json['fullName'],
    age: json['age'],
    education: json['education'],
    specialization: json['specialization'],
    experience: json['experience'],
    motivation: json['motivation'],
    certificates: List<String>.from(json['certificates']),
    hasPsychologyEducation: json['hasPsychologyEducation'],
    organization: json['organization'],
    appliedAt: DateTime.fromMillisecondsSinceEpoch(json['appliedAt']),
    status: VolunteerStatus.values[json['status']],
    reviewComment: json['reviewComment'],
    reviewedAt: json['reviewedAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['reviewedAt'])
        : null,
    reviewerId: json['reviewerId'],
  );
}