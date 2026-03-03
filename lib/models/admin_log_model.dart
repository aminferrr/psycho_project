enum AdminActionType {
  approveVolunteer,
  rejectVolunteer,
  blockUser,
  unblockUser,
  deletePost,
  editPractice,
  addPractice,
  deletePractice,
  viewStats,
  other
}

class AdminLog {
  final String id;
  final String adminId;
  final String adminEmail;
  final AdminActionType actionType;
  final String description;
  final Map<String, dynamic>? metadata; // дополнительные данные
  final String? targetUserId; // пользователь, над которым действие
  final String? targetId; // id объекта (поста, практики и т.д.)
  final DateTime timestamp;

  AdminLog({
    required this.id,
    required this.adminId,
    required this.adminEmail,
    required this.actionType,
    required this.description,
    this.metadata,
    this.targetUserId,
    this.targetId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'adminId': adminId,
    'adminEmail': adminEmail,
    'actionType': actionType.index,
    'description': description,
    'metadata': metadata,
    'targetUserId': targetUserId,
    'targetId': targetId,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory AdminLog.fromJson(Map<String, dynamic> json) => AdminLog(
    id: json['id'],
    adminId: json['adminId'],
    adminEmail: json['adminEmail'],
    actionType: AdminActionType.values[json['actionType']],
    description: json['description'],
    metadata: json['metadata'],
    targetUserId: json['targetUserId'],
    targetId: json['targetId'],
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
  );
}