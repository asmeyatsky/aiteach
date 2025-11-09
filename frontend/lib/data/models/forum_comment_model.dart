import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/data/models/user_model.dart';

part 'forum_comment_model.g.dart';

@JsonSerializable()
class ForumCommentModel {
  ForumCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.owner,
  });

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) => _$ForumCommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ForumCommentModelToJson(this);

  final int id;
  final int postId;
  final int userId;
  final String body;
  final DateTime createdAt;
  final UserModel owner;
}
