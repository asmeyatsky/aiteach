// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_proficiency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProficiencyModel _$UserProficiencyModelFromJson(
  Map<String, dynamic> json,
) => UserProficiencyModel(
  userId: (json['userId'] as num).toInt(),
  selectedLevel: const ProficiencyLevelConverter().fromJson(
    json['selectedLevel'] as String,
  ),
  assessmentScore: (json['assessmentScore'] as num).toDouble(),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$UserProficiencyModelToJson(
  UserProficiencyModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'selectedLevel': const ProficiencyLevelConverter().toJson(
    instance.selectedLevel,
  ),
  'assessmentScore': instance.assessmentScore,
  'lastUpdated': instance.lastUpdated.toIso8601String(),
};
