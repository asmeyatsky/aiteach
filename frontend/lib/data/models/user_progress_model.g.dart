// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgressModel _$UserProgressModelFromJson(Map<String, dynamic> json) =>
    UserProgressModel(
      userId: (json['userId'] as num).toInt(),
      lessonId: (json['lessonId'] as num).toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      lesson: json['lesson'] == null
          ? null
          : LessonModel.fromJson(json['lesson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProgressModelToJson(UserProgressModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lessonId': instance.lessonId,
      'completedAt': instance.completedAt.toIso8601String(),
      'lesson': instance.lesson,
    };
