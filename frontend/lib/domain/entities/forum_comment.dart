// frontend/lib/domain/entities/forum_comment.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/user.dart';

class ForumComment extends Equatable {
  final int id;
  final int postId;
  final int userId;
  final String body;
  final DateTime createdAt;
  final User owner; // Assuming owner is always loaded with the comment

  const ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.owner,
  });

  @override
  List<Object?> get props => [id, postId, userId, body, createdAt, owner];
}
