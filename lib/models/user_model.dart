enum UserRole {
  user,        // обычный пользователь
  volunteer,   // волонтер (на рассмотрении)
  psychologist,// подтвержденный психолог
  admin        // администратор
}

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String subscription;
  final Map<String, dynamic> settings;

  // Новые поля
  final UserRole role;
  final bool isApproved; // для волонтеров
  final DateTime? volunteerApplicationDate;
  final String? volunteerId; // ссылка на профиль волонтера

  // Права администратора (опционально)
  final List<String>? adminPermissions; // ['manage_users', 'manage_practices', 'view_stats']

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.lastLogin,
    this.subscription = 'free',
    this.settings = const {},
    this.role = UserRole.user,
    this.isApproved = false,
    this.volunteerApplicationDate,
    this.volunteerId,
    this.adminPermissions,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin.millisecondsSinceEpoch,
      'subscription': subscription,
      'settings': settings,
      'role': role.index,
      'isApproved': isApproved,
      'volunteerApplicationDate': volunteerApplicationDate?.millisecondsSinceEpoch,
      'volunteerId': volunteerId,
      'adminPermissions': adminPermissions,
    };
  }

  static DateTime _dateFromJson(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    if (v is DateTime) return v;
    // Firestore Timestamp
    try {
      return (v as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] ?? json['name'],
      photoURL: json['photoURL'],
      createdAt: _dateFromJson(json['createdAt']),
      lastLogin: _dateFromJson(json['lastLogin']),
      subscription: json['subscription'] ?? 'free',
      settings: json['settings'] != null ? Map<String, dynamic>.from(json['settings']) : {},
      role: json['role'] != null ? UserRole.values[json['role'] as int] : UserRole.user,
      isApproved: json['isApproved'] ?? false,
      volunteerApplicationDate: json['volunteerApplicationDate'] != null
          ? _dateFromJson(json['volunteerApplicationDate'])
          : null,
      volunteerId: json['volunteerId'],
      adminPermissions: json['adminPermissions'] != null
          ? List<String>.from(json['adminPermissions'])
          : null,
    );
  }

  // Helper для проверки прав
  bool hasPermission(String permission) {
    if (role != UserRole.admin) return false;
    return adminPermissions?.contains(permission) ?? false;
  }
}