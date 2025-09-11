// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
  userId: (json['userId'] as num).toInt(),
  lessonId: (json['lessonId'] as num).toInt(),
  completedAt: DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lessonId': instance.lessonId,
      'completedAt': instance.completedAt.toIso8601String(),
    };
