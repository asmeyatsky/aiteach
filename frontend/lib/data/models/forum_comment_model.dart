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
  @JsonKey(name: 'post_id')
  final int postId;
  @JsonKey(name: 'user_id')
  final int userId;
  final String body;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final UserModel owner;
}
