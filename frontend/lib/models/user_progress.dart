import 'package:json_annotation/json_annotation.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress {
  UserProgress({
    required this.userId,
    required this.lessonId,
    required this.completedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) => _$UserProgressFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  final int userId;
  final int lessonId;
  final DateTime completedAt;
}
