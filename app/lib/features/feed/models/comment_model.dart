class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userTradeName;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userTradeName,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isVendorAuthor => userTradeName != null && userTradeName!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'user_name': userName,
      'user_trade_name': userTradeName,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id']?.toString() ?? '',
      postId: (json['post_id'] ?? json['postId'])?.toString() ?? '',
      userId: (json['user_id'] ?? json['userId'])?.toString() ?? '',
      userName: (json['user_name'] ?? json['userName'])?.toString() ?? 'Usuário',
      userTradeName: (json['user_trade_name'] ?? json['userTradeName'])?.toString(),
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userTradeName,
    String? content,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userTradeName: userTradeName ?? this.userTradeName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
