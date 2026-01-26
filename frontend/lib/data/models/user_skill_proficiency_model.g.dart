// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_skill_proficiency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSkillProficiencyModel _$UserSkillProficiencyModelFromJson(
  Map<String, dynamic> json,
) => UserSkillProficiencyModel(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  skill: json['skill'] as String,
  level: (json['level'] as num).toInt(),
);

Map<String, dynamic> _$UserSkillProficiencyModelToJson(
  UserSkillProficiencyModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'skill': instance.skill,
  'level': instance.level,
};
