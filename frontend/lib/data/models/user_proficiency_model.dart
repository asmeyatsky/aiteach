import 'package:json_annotation/json_annotation.dart';

part 'user_proficiency_model.g.dart';

class ProficiencyLevelConverter implements JsonConverter<ProficiencyLevel, String> {
  const ProficiencyLevelConverter();

  @override
  ProficiencyLevel fromJson(String json) {
    return ProficiencyLevel.values.firstWhere((e) => e.toString() == 'ProficiencyLevel.' + json);
  }

  @override
  String toJson(ProficiencyLevel object) {
    return object.toString().split('.').last;
  }
}

@JsonSerializable()
class UserProficiencyModel {
  UserProficiencyModel({
    required this.userId,
    required this.selectedLevel,
    required this.assessmentScore,
    required this.lastUpdated,
  });

  factory UserProficiencyModel.fromJson(Map<String, dynamic> json) => _$UserProficiencyModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProficiencyModelToJson(this);

  final int userId;
  @ProficiencyLevelConverter()
  final ProficiencyLevel selectedLevel;
  final double assessmentScore;
  final DateTime lastUpdated;
}

enum ProficiencyLevel {
  beginner,
  intermediate,
  advanced,
}