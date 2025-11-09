// frontend/lib/data/models/course_recommendation_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/user_proficiency.dart'; // Assuming ProficiencyLevel is still used

part 'course_recommendation_model.g.dart';

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
class CourseRecommendationModel {
  final int id;
  final String title;
  final String description;
  final String category;
  @ProficiencyLevelConverter()
  final ProficiencyLevel recommendedLevel;
  final int estimatedHours;
  final double rating;
  final int enrolledCount;
  final List<String> skillsCovered;

  CourseRecommendationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.recommendedLevel,
    required this.estimatedHours,
    required this.rating,
    required this.enrolledCount,
    required this.skillsCovered,
  });

  factory CourseRecommendationModel.fromJson(Map<String, dynamic> json) => _$CourseRecommendationModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourseRecommendationModelToJson(this);
}
