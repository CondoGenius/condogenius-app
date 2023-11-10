import 'package:condo_genius_beta/models/user_model.dart';

class Comment {
  final int id;
  final User user;
  final int postId;
  final String content;


  Comment({
    required this.id,
    required this.user,
    required this.postId,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      user: User.fromJson(json['user']),
      postId: json['post_id'],
      content: json['content']
    );
  }
}
