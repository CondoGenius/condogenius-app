import 'package:condo_genius_beta/models/user_model.dart';

class Comment {
  final int id;
  final int userId;
  final int postId;
  final String content;
  final String createdAt;
  final String updatedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

