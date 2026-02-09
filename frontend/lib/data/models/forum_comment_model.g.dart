// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumCommentModel _$ForumCommentModelFromJson(Map<String, dynamic> json) =>
    ForumCommentModel(
      id: (json['id'] as num).toInt(),
      postId: (json['post_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      owner: UserModel.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForumCommentModelToJson(ForumCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'user_id': instance.userId,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'owner': instance.owner,
    };
