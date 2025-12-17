class Comment {
  final int id;
  final int reportId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      reportId: json['report_id'] as int,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String? ?? 'Usuário',
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_id': reportId,
      'user_id': userId,
      'user_name': userName,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
