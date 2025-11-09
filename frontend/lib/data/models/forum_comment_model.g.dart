// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumCommentModel _$ForumCommentModelFromJson(Map<String, dynamic> json) =>
    ForumCommentModel(
      id: (json['id'] as num).toInt(),
      postId: (json['postId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      owner: UserModel.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForumCommentModelToJson(ForumCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'owner': instance.owner,
    };
