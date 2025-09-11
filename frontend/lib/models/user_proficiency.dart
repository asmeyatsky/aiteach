import 'package:json_annotation/json_annotation.dart';

part 'user_proficiency.g.dart';

@JsonSerializable()
class UserProficiency {
  UserProficiency({
    required this.userId,
    required this.selectedLevel,
    required this.assessmentScore,
    required this.lastUpdated,
  });

  factory UserProficiency.fromJson(Map<String, dynamic> json) => _$UserProficiencyFromJson(json);
  Map<String, dynamic> toJson() => _$UserProficiencyToJson(this);

  final int userId;
  final ProficiencyLevel selectedLevel;
  final double assessmentScore;
  final DateTime lastUpdated;
}

enum ProficiencyLevel {
  beginner,
  intermediate,
  advanced,
}