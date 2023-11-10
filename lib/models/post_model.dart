import 'package:condo_genius_beta/models/poll_model.dart';
import 'package:condo_genius_beta/models/user_model.dart';
import 'package:condo_genius_beta/models/comment_model.dart';

class Post {
  final int id;
  final int userId;
  final String content;
  final bool fixed;
  final String createdAt;
  final String updatedAt;
  final User user;
  final Poll? poll;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.fixed,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.poll,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      fixed: json['fixed'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['user']),
      poll: json['poll'] != null && json['poll'].isNotEmpty ? Poll.fromJson(json['poll']) : null,
      comments: (json['comments'] as List)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
    );
  }
}
