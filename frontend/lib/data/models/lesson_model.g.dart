// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
  id: (json['id'] as num).toInt(),
  courseId: (json['course_id'] as num).toInt(),
  title: json['title'] as String,
  contentType: json['content_type'] as String,
  contentData: json['content_data'] as String,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'title': instance.title,
      'content_type': instance.contentType,
      'content_data': instance.contentData,
      'order': instance.order,
    };
