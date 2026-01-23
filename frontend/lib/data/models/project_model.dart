import 'package:json_annotation/json_annotation.dart';

part 'project_model.g.dart';

@JsonSerializable()
class Project {
  final int id;
  final String track; // user, builder, innovator
  final String title;
  final String description;
  final String? starterCodeUrl;
  final String difficulty; // easy, medium, hard

  Project({
    required this.id,
    required this.track,
    required this.title,
    required this.description,
    this.starterCodeUrl,
    required this.difficulty,
  });

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

@JsonSerializable()
class UserProject {
  final int id;
  final int userId;
  final int projectId;
  final String status; // not_started, in_progress, completed
  final String? submissionUrl;

  UserProject({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.status,
    this.submissionUrl,
  });

  factory UserProject.fromJson(Map<String, dynamic> json) => _$UserProjectFromJson(json);
  Map<String, dynamic> toJson() => _$UserProjectToJson(this);
}