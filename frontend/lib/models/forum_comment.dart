import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/user.dart';

part 'forum_comment.g.dart';

@JsonSerializable()
class ForumComment {
  ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.owner,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) => _$ForumCommentFromJson(json);
  Map<String, dynamic> toJson() => _$ForumCommentToJson(this);

  final int id;
  final int postId;
  final int userId;
  final String body;
  final DateTime createdAt;
  final User owner;
}
