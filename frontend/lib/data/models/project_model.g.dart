// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  id: (json['id'] as num).toInt(),
  track: json['track'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  starterCodeUrl: json['starterCodeUrl'] as String?,
  difficulty: json['difficulty'] as String,
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  'id': instance.id,
  'track': instance.track,
  'title': instance.title,
  'description': instance.description,
  'starterCodeUrl': instance.starterCodeUrl,
  'difficulty': instance.difficulty,
};

UserProject _$UserProjectFromJson(Map<String, dynamic> json) => UserProject(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  projectId: (json['projectId'] as num).toInt(),
  status: json['status'] as String,
  submissionUrl: json['submissionUrl'] as String?,
);

Map<String, dynamic> _$UserProjectToJson(UserProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'projectId': instance.projectId,
      'status': instance.status,
      'submissionUrl': instance.submissionUrl,
    };
