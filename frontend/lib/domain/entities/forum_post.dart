// frontend/lib/domain/entities/forum_post.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/domain/entities/forum_comment.dart';

class ForumPost extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime createdAt;
  final User owner;
  final List<ForumComment> comments;

  const ForumPost({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.comments,
  });

  @override
  List<Object?> get props => [id, userId, title, body, createdAt, owner, comments];
}
