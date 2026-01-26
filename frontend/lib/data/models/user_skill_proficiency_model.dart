import 'package:json_annotation/json_annotation.dart';

part 'user_skill_proficiency_model.g.dart';

@JsonSerializable()
class UserSkillProficiencyModel {
  UserSkillProficiencyModel({
    required this.id,
    required this.userId,
    required this.skill,
    required this.level,
  });

  factory UserSkillProficiencyModel.fromJson(Map<String, dynamic> json) => _$UserSkillProficiencyModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserSkillProficiencyModelToJson(this);

  final int id;
  final int userId;
  final String skill;
  final int level;
}