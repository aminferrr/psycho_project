class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String subscription;
  final Map<String, dynamic> settings;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.lastLogin,
    this.subscription = 'free',
    this.settings = const {},
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
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      lastLogin: DateTime.fromMillisecondsSinceEpoch(json['lastLogin']),
      subscription: json['subscription'] ?? 'free',
      settings: json['settings'] ?? {},
    );
  }
}