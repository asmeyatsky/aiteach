// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgressModel _$UserProgressModelFromJson(Map<String, dynamic> json) =>
    UserProgressModel(
      userId: (json['user_id'] as num).toInt(),
      lessonId: (json['lesson_id'] as num).toInt(),
      completedAt: DateTime.parse(json['completed_at'] as String),
      lesson: json['lesson'] == null
          ? null
          : LessonModel.fromJson(json['lesson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProgressModelToJson(UserProgressModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'lesson_id': instance.lessonId,
      'completed_at': instance.completedAt.toIso8601String(),
      'lesson': instance.lesson,
    };
