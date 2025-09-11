import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.contentType,
    required this.contentData,
    required this.order,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);

  final int id;
  final int courseId;
  final String title;
  final String contentType;
  final String contentData;
  final int order;
}
