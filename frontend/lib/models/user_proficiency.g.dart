// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_proficiency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProficiency _$UserProficiencyFromJson(Map<String, dynamic> json) =>
    UserProficiency(
      userId: (json['userId'] as num).toInt(),
      selectedLevel: $enumDecode(
        _$ProficiencyLevelEnumMap,
        json['selectedLevel'],
      ),
      assessmentScore: (json['assessmentScore'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserProficiencyToJson(UserProficiency instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'selectedLevel': _$ProficiencyLevelEnumMap[instance.selectedLevel]!,
      'assessmentScore': instance.assessmentScore,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$ProficiencyLevelEnumMap = {
  ProficiencyLevel.beginner: 'beginner',
  ProficiencyLevel.intermediate: 'intermediate',
  ProficiencyLevel.advanced: 'advanced',
};
