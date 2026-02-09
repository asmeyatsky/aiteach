import 'package:json_annotation/json_annotation.dart';

part 'lesson_model.g.dart';

@JsonSerializable()
class LessonModel {
  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.contentType,
    required this.contentData,
    required this.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) => _$LessonModelFromJson(json);
  Map<String, dynamic> toJson() => _$LessonModelToJson(this);

  final int id;
  @JsonKey(name: 'course_id')
  final int courseId;
  final String title;
  @JsonKey(name: 'content_type')
  final String contentType;
  @JsonKey(name: 'content_data')
  final String contentData;
  final int order;
}
