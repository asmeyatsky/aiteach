import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    this.thumbnailUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);

  final int id;
  final String title;
  final String description;
  final String tier;
  final String? thumbnailUrl;
}
