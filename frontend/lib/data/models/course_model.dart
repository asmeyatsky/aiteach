import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable()
class CourseModel {
  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    this.thumbnailUrl,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  final int id;
  final String title;
  final String description;
  final String tier;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
}
