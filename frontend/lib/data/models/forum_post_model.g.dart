// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPostModel _$ForumPostModelFromJson(Map<String, dynamic> json) =>
    ForumPostModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      owner: UserModel.fromJson(json['owner'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => ForumCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ForumPostModelToJson(ForumPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'owner': instance.owner,
      'comments': instance.comments,
    };
