import 'package:condo_genius_beta/models/user_model.dart';

class Comment {
  final int id;
  final User user;
  final int postId;
  final String content;
  final String createdAt;
  final String updatedAt;


  Comment({
    required this.id,
    required this.user,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      user: User.fromJson(json['user']),
      postId: json['post_id'],
      content: json['content'],
      createdAt: json['created_at'] ?? json['createdAt'],
      updatedAt: json['updated_at'] ?? json['updatedAt'],
    );
  }
}
