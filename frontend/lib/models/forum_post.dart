import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/forum_comment.dart';

part 'forum_post.g.dart';

@JsonSerializable()
class ForumPost {
  ForumPost({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.comments,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) => _$ForumPostFromJson(json);
  Map<String, dynamic> toJson() => _$ForumPostToJson(this);

  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime createdAt;
  final User owner;
  final List<ForumComment> comments;
}
