enum VolunteerStatus { pending, approved, rejected }

class VolunteerProfile {
  final String id;
  final String userId;
  final String fullName;
  final int age;
  final String education;
  final String specialization;
  final String experience;
  final String motivation;
  final String? organization;
  final String? photoUrl;
  final bool hasPsychologyEducation;
  final VolunteerStatus status;
  final DateTime appliedAt;
  final DateTime? reviewedAt;
  final String? reviewerId;
  final String? reviewComment;
  final String? phoneNumber; // Номер телефона для связи

  VolunteerProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.age,
    required this.education,
    required this.specialization,
    required this.experience,
    required this.motivation,
    this.organization,
    this.photoUrl,
    required this.hasPsychologyEducation,
    required this.status,
    required this.appliedAt,
    this.reviewedAt,
    this.reviewerId,
    this.reviewComment,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'age': age,
      'education': education,
      'specialization': specialization,
      'experience': experience,
      'motivation': motivation,
      'organization': organization,
      'photoUrl': photoUrl,
      'hasPsychologyEducation': hasPsychologyEducation,
      'status': status.index,
      'appliedAt': appliedAt.millisecondsSinceEpoch,
      'reviewedAt': reviewedAt?.millisecondsSinceEpoch,
      'reviewerId': reviewerId,
      'reviewComment': reviewComment,
      'phoneNumber': phoneNumber,
    };
  }

  factory VolunteerProfile.fromJson(Map<String, dynamic> json) {
    return VolunteerProfile(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      age: json['age'] ?? 0,
      education: json['education'] ?? '',
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? '',
      motivation: json['motivation'] ?? '',
      organization: json['organization'],
      photoUrl: json['photoUrl'],
      hasPsychologyEducation: json['hasPsychologyEducation'] ?? false,
      status: VolunteerStatus.values[json['status'] ?? 0],
      appliedAt: json['appliedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['appliedAt'])
          : DateTime.now(),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['reviewedAt'])
          : null,
      reviewerId: json['reviewerId'],
      reviewComment: json['reviewComment'],
      phoneNumber: json['phoneNumber'],
    );
  }
}