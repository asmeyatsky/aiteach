import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/data/models/lesson_model.dart'; // Import the new model

part 'user_progress_model.g.dart';

@JsonSerializable()
class UserProgressModel {
  UserProgressModel({
    required this.userId,
    required this.lessonId,
    required this.completedAt,
    this.lesson, // Add lesson to constructor
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) => _$UserProgressModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressModelToJson(this);

  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'lesson_id')
  final int lessonId;
  @JsonKey(name: 'completed_at')
  final DateTime completedAt;
  final LessonModel? lesson; // Add lesson field
}
