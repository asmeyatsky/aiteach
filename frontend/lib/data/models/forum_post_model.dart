import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/data/models/forum_comment_model.dart';

part 'forum_post_model.g.dart';

@JsonSerializable()
class ForumPostModel {
  ForumPostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.comments,
  });

  factory ForumPostModel.fromJson(Map<String, dynamic> json) => _$ForumPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$ForumPostModelToJson(this);

  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime createdAt;
  final UserModel owner;
  final List<ForumCommentModel> comments;
}
