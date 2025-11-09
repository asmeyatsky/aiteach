// frontend/lib/domain/entities/forum_post.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/user.dart';

class ForumPost extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime createdAt;
  final User owner; // Assuming owner is always loaded with the post

  const ForumPost({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.owner,
  });

  @override
  List<Object?> get props => [id, userId, title, body, createdAt, owner];
}
