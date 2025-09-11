// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
  id: (json['id'] as num).toInt(),
  courseId: (json['courseId'] as num).toInt(),
  title: json['title'] as String,
  contentType: json['contentType'] as String,
  contentData: json['contentData'] as String,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'courseId': instance.courseId,
  'title': instance.title,
  'contentType': instance.contentType,
  'contentData': instance.contentData,
  'order': instance.order,
};
